#!/bin/bash
source $(dirname $0)/elfenSetting.sh

if [ ! -d "${TARGET_DIR}" ]; then
    mkdir ${TARGET_DIR};
fi

echo "Compiling Lucene"

/home/yangxi/code/jdk9/build/linux-x86_64-normal-server-release/jdk/bin/javac -d ${TARGET_DIR} -classpath "${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${LUCENE_BUILD}" ${LUCENE_UTIL}/src/main/perf/Affinity.java ${LUCENE_UTIL}/src/main/perf/Args.java ${LUCENE_UTIL}/src/main/perf/IndexState.java ${LUCENE_UTIL}/src/main/perf/IndexThreads.java ${LUCENE_UTIL}/src/main/perf/NRTPerfTest.java ${LUCENE_UTIL}/src/main/perf/Indexer.java ${LUCENE_UTIL}/src/main/perf/KeepNoCommitsDeletionPolicy.java ${LUCENE_UTIL}/src/main/perf/LineFileDocs.java ${LUCENE_UTIL}/src/main/perf/LocalTaskSource.java ${LUCENE_UTIL}/src/main/perf/OpenDirectory.java ${LUCENE_UTIL}/src/main/perf/PKLookupTask.java ${LUCENE_UTIL}/src/main/perf/PerfUtils.java ${LUCENE_UTIL}/src/main/perf/RandomQuery.java ${LUCENE_UTIL}/src/main/perf/RemoteTaskSource.java ${LUCENE_UTIL}/src/main/perf/RespellTask.java ${LUCENE_UTIL}/src/main/perf/SearchPerfTest.java ${LUCENE_UTIL}/src/main/perf/SearchTask.java ${LUCENE_UTIL}/src/main/perf/StatisticsHelper.java ${LUCENE_UTIL}/src/main/perf/Task.java ${LUCENE_UTIL}/src/main/perf/TaskParser.java ${LUCENE_UTIL}/src/main/perf/TaskSource.java ${LUCENE_UTIL}/src/main/perf/TaskThreads.java

#javac -d /home/xyang/benchmark/lucene-reg/util/build -classpath "/home/xyang/benchmark/lucene-reg/patch/lucene/build/core/lucene-core-8.0.0-SNAPSHOT.jar:/home/xyang/benchmark/lucene-reg/patch/lucene/build/core/classes/test:/home/xyang/benchmark/lucene-reg/patch/lucene/build/sandbox/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/build/misc/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/build/facet/classes/java:/home/mike/src/lucene-c-boost/dist/luceneCBoost-SNAPSHOT.jar:/home/xyang/benchmark/lucene-reg/patch/lucene/build/analysis/common/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/build/analysis/icu/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/build/queryparser/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/build/grouping/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/build/suggest/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/build/highlighter/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/build/codecs/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/build/queries/classes/java:/home/xyang/benchmark/lucene-reg/patch/lucene/facet/lib/hppc-0.7.3.jar:/home/xyang/benchmark/lucene-reg/util/lib/HdrHistogram.jar:/home/xyang/benchmark/lucene-reg/util/build" /home/xyang/benchmark/lucene-reg/util/src/main/perf/Args.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/IndexState.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/IndexThreads.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/NRTPerfTest.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/Indexer.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/KeepNoCommitsDeletionPolicy.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/LineFileDocs.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/LocalTaskSource.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/OpenDirectory.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/PKLookupTask.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/PointsPKLookupTask.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/PerfUtils.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/RandomQuery.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/RemoteTaskSource.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/RespellTask.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/SearchPerfTest.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/SearchTask.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/StatisticsHelper.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/Task.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/TaskParser.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/TaskSource.java /home/xyang/benchmark/lucene-reg/util/src/main/perf/TaskThreads.java, cwd=/home/xyang/benchmark/lucene-reg/trunk/lucene/benchmark

echo "Compiling elfen_signal"

gcc -O2 -g  -D_GNU_SOURCE -fPIC -shared -std=c99 -fPIC ${LUCENE_UTIL}/src/main/perf/elfen_signal.c -o ${TARGET_DIR}/perf/libelfen_signal.so $@ -I"${JDK_PATH}"/include -I"${JDK_PATH}"/include/linux/ -pthread -lpfm


#sudo chrt -r 99 java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Xbatch -Djava.library.path=${TARGET_DIR}/native -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${LUCENE_BUILD} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount ${SEARCH_THREAD} -taskRepeatCount 20 -field body -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk

#java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Xbatch -Djava.library.path=${TARGET_DIR}/native -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${LUCENE_BUILD} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 1 -taskRepeatCount 20 -field body -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk
