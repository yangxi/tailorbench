#!/bin/bash
source $(dirname $0)/elfenSetting.sh

echo "Create index directory ${INDEX_DIR}. It may take hours with a large -docCountLimit!"
NR_INDEX_DOC=10000000
INDEX_DIRECTORY=${INDEX_ROOT}/wikimedium10k.trunk.facets.taxonomy:Date.taxonomy:Month.taxonomy:DayOfYear.sortedset:Month.sortedset:DayOfYear.Lucene70.Lucene50.nd10M
if [ -d "${INDEX_DIRECTORY}" ]; then
    echo "Index ${INDEX_DIRECTORY} exists."
    exit 0;
fi


java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Djava.library.path=${TARGET_DIR}/perf -classpath "${LUCENE_BUILD}/core/lucene-core-8.0.0-SNAPSHOT.jar:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_ROOT}/lucene/facet/lib/hppc-0.7.3.jar:${LUCENE_UTIL}/lib/HdrHistogram.jar:${LUCENE_UTIL}/build" perf.Indexer -dirImpl MMapDirectory -indexPath ${INDEX_DIRECTORY} -analyzer StandardAnalyzer -lineDocsFile ${SOURCE_DATA} -docCountLimit ${NR_INDEX_DOC} -threadCount 1 -maxConcurrentMerges 1 -ramBufferMB -1 -maxBufferedDocs 18 -postingsFormat Lucene50 -waitForMerges -mergePolicy LogDocMergePolicy -facets "taxonomy:Date;Date" -facets "taxonomy:Month;Month" -facets "taxonomy:DayOfYear;DayOfYear" -facets "sortedset:Month;Month" -facets "sortedset:DayOfYear;DayOfYear" -facetDVFormat Lucene70 -idFieldPostingsFormat Lucene50 -grouping -waitForCommit

#java -server -Xms2g -Xmx2g -XX:-TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -Xbatch -classpath "${LUCENE_BUILD}/core/classes/java:${LUCENE_BUILD}/core/classes/test:${LUCENE_BUILD}/sandbox/classes/java:${LUCENE_BUILD}/misc/classes/java:${LUCENE_BUILD}/facet/classes/java:${LUCENE_BUILD}/analysis/common/classes/java:${LUCENE_BUILD}/analysis/icu/classes/java:${LUCENE_BUILD}/queryparser/classes/java:${LUCENE_BUILD}/grouping/classes/java:${LUCENE_BUILD}/suggest/classes/java:${LUCENE_BUILD}/highlighter/classes/java:${LUCENE_BUILD}/codecs/classes/java:${LUCENE_BUILD}/queries/classes/java:${LUCENE_UTIL}/lib/HdrHistogram.jar:${TARGET_DIR}" perf.Indexer -dirImpl MMapDirectory -indexPath ${INDEX_DIR} -analyzer StandardAnalyzer -lineDocsFile ${SOURCE_DATA} -docCountLimit 10000000 -threadCount 1 -maxConcurrentMerges 1 -ramBufferMB -1 -maxBufferedDocs 18 -postingsFormat Lucene50 -waitForMerges -mergePolicy LogDocMergePolicy -idFieldPostingsFormat Memory -grouping
