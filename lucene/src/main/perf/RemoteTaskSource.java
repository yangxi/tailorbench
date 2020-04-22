package perf;

/**
 * perf to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

import perf.Affinity;

// Serves up tasks from remote client
class RemoteTaskSource extends Thread implements TaskSource {
  private final ServerSocket serverSocket;
  private final TaskParser taskParser;
  private final int numThreads;
  private final int cpuAffinityBase;
  private static final int MAX_BYTES = 40;
    private final boolean nodelay_sock;

  // nocommit maybe fair=true?
  private final BlockingQueue<Task> queue = new ArrayBlockingQueue<Task>(100000);

    public RemoteTaskSource(String iface, int port, int numThreads, TaskParser taskParser, int cpuAffinity, boolean nodelay_sock) throws IOException {
    this.numThreads = numThreads;
    this.taskParser = taskParser;
    this.cpuAffinityBase = cpuAffinity;
    this.nodelay_sock = nodelay_sock;
    serverSocket = new ServerSocket(port, 50, InetAddress.getByName(iface));
    System.out.println("Waiting for client connection on interface " + iface + ", port " + port);
    setPriority(Thread.MAX_PRIORITY);
    setDaemon(true);
    start();
  }

  @Override
  public List<Task> getAllTasks() {
    return null;
  }

  private volatile OutputStream out;

  @Override
  public void run() {
    // Start server socket and accept only one client
    // connection, which will feed us the requests:
    System.out.println("RemoteTaskSource is running, pin itself on CPU" + this.numThreads);
    if (cpuAffinityBase != -1)
	Affinity.setCPUAffinity(this.numThreads + this.cpuAffinityBase);
    String[] eventNames = {"INSTRUCTION_RETIRED","UNHALTED_CORE_CYCLES"};
//    String[] eventNames = {"INSTRUCTION_RETIRED","INSTRUCTION_RETIRED:k"};
    Affinity.createEvents(eventNames);
    newClient: while(true) {
      //reset the flag
      Affinity.postSignal(-1,-1,this.numThreads);
      Socket socket = null;
      InputStream in;
      try {
        System.out.println("  ready for client...");
        socket = serverSocket.accept();
	if (this.nodelay_sock == true)
	{
	    socket.setTcpNoDelay(true);
	}
        in = socket.getInputStream();
        out = socket.getOutputStream();
      } catch (IOException ioe) {
        if (socket != null) {
          try {
            socket.close();
          } catch (IOException ioe2) {
          }
        }
        continue;
      }
      System.out.println("    connection!");

      try {
        final byte[] buffer = new byte[MAX_BYTES];
        int taskCount = 0;
        while(true) {
          int upto = 0;
          while(upto < buffer.length) {
            final int inc;
            try {
              inc = in.read(buffer, upto, MAX_BYTES-upto);
            } catch (java.net.SocketException se) {
              socket.close();
              queue.clear();
              out = null;
              continue newClient;
            }
            if (inc >= 0) {
              upto += inc;
            } else {
              // Connection closed
              socket.close();
              queue.clear();
              out = null;
              continue newClient;
            }
          }

          String s = new String(buffer, "UTF-8");
	  if (s.startsWith("#dummy")){
	      continue;
	  }

          // if (s.startsWith("END//")) {
          //   for(int threadID=0;threadID<numThreads;threadID++) {
          //     queue.put(Task.END_TASK);
          //   }
          //   break;
          // }
	  // id;type; term
	  String[] stuple = s.split(";");
	  //	  System.out.println("Receive Task " + s);;
	  String taskString = stuple[1];
          Task task;
          try {
            task = taskParser.parseOneTask(taskString);
          } catch (RuntimeException re) {
            re.printStackTrace();
            continue;
          }
	  task.taskID = Integer.parseInt(stuple[0].replaceAll("\\s","").trim());
          task.recvTimeNS = System.nanoTime();
	  //          task.taskID = taskCount++;
	  //enqueue task.taskID
	  Affinity.postSignal(1,task.taskID,this.numThreads);
          queue.put(task);
	  //	  Affinity.postEnqueSignal();
	  //	  System.out.println("S: add " + task.taskID + ":" + taskString + "; size=" + queue.size() + "; socket=" + in.available());
        }
      } catch (Exception e) {
        throw new RuntimeException(e);
      }
    }
  }

  @Override
  public Task nextTask() throws InterruptedException {
    return queue.take();
  }

  @Override
  public void taskDone(Task task, long queueTimeNS, long processTimeNS, int totalHitCount) throws IOException {
    if (out != null) {
      try {
        // NOTE: can cause NPE here (we are not sync'd)
        // but caller will print & ignore it...
	synchronized(out){
	  out.write(String.format(Locale.ENGLISH, "%8d:%9d:%16d:%16d", task.taskID, totalHitCount, queueTimeNS, processTimeNS).getBytes("UTF-8"));
	}
      } catch (SocketException se) {
        System.out.println("Ignore SocketException: " + se);
        queue.clear();
      } catch (UnsupportedEncodingException uee) {
        throw new RuntimeException(uee);
      }
    }
  }

  public void taskReport(Task task, int totalHitCount, long receiveTime, long processTime, long finishTime, long ins, long cycles) throws IOException {
    if (out != null) {
      try {
        // NOTE: can cause NPE here (we are not sync'd)
        // but caller will print & ignore it...
	  //	long t1 = System.nanoTime();
	  synchronized(out){
	      out.write(String.format(Locale.ENGLISH, "%8d:%9d:%16d:%16d:%16d:%16d:%16d", task.taskID, totalHitCount, receiveTime, processTime-receiveTime, finishTime-receiveTime, ins, cycles).getBytes("UTF-8"));}
	//	long t2 = System.nanoTime();
	//	long writeLatency = t2 - t1;
	//	System.out.println(task.taskID + ":"  + writeLatency);
      } catch (SocketException se) {
        System.out.println("Ignore SocketException: " + se);
        queue.clear();
      } catch (UnsupportedEncodingException uee) {
        throw new RuntimeException(uee);
      }
    }
  }
}
