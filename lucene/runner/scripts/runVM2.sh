#!/bin/bash
source $(dirname $0)/td2VM2Setting.sh
INDEX_DIR="${LUCENE_UTIL}/../indices/wikimedium10k.trunk.facets.taxonomy:Date.taxonomy:Month.taxonomy:DayOfYear.sortedset:Month.sortedset:DayOfYear.Lucene70.Lucene50.nd0.1M"

#/home/xyang/print_domain.sh 4783 559

#-XX:TieredStopAtLevel=1
#${JAVA_HOME}/bin/java -server -Xms500m -Xmx500m -XX:TieredStopAtLevel=1 -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 6 -taskRepeatCount 20 -field body -cpuAffinity 0 -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk
#/home/yangxi/code/jdk9/build/linux-x86_64-normal-server-release/jdk/bin/java -server -Xms2g -Xmx2g -XX:TieredStopAtLevel=1 -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 1 -taskRepeatCount 20 -field body -cpuAffinity 0 -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk
taskset 0x7f00 /home/yangxi/code/jdk9/build/linux-x86_64-normal-server-release/jdk/bin/java -server -Xms2g -Xmx2g -XX:CICompilerCount=3 -XX:ParallelGCThreads=7 -XX:TieredStopAtLevel=1 -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 6 -taskRepeatCount 20 -field body -cpuAffinity 8 -nodelay -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk

#${JAVA_HOME}/bin/java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Xbatch -Djava.library.path=${TARGET_DIR}/perf -classpath ${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR} perf.SearchPerfTest -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -taskSource ${SERVER_IP} -searchThreadCount 7 -taskRepeatCount 20 -field body -cpuAffinity 0 -tasksPerCat -1 -staticSeed -0 -seed 0 -similarity BM25Similarity -commit multi -hiliteImpl FastVectorHighlighter -log ${LOG_FILE} -topN 10 -pk
