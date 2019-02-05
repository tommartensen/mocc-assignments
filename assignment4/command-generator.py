#!/bin/python

iterations = [1,10,100,1000]
cluster_counts = [1,10,100,1000]

for i in iterations:
    for k in cluster_counts:
        command = 'aws emr add-steps --cluster-id j-TR90EWT9EGXU --steps Type=CUSTOM_JAR,Name=Flink-CellCluster,Jar=command-runner.jar,Args="flink","run","-m","yarn-cluster","-yn","3","/home/hadoop/cellclusters-0.0.1.jar","--input","s3://mocc-bucket/berlin.csv","--output","s3://mocc-bucket/berlin-cluster-i-{}-k-{}.csv","--mnc","20\,78\,1","--iterations","{}","--k","{}"'.format(i, k, i, k)
        print(command)