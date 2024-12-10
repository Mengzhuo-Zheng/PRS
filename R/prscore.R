prscore <- function(dist_matrix,sample_matrix){
  colnames(sample_matrix)<-c("sample","cluster")
  score<-data.frame(
    sample=sample_matrix$sample,
    score=0
  )
  for (i in unique(sample_matrix$cluster)) {
    cluster_samples<-sample_matrix[sample_matrix$cluster==i,"sample"]
    for (j in cluster_samples) {
      score_inter=sqrt(sum(as.numeric(dist_matrix[j,cluster_samples])^2))
      score_intra=sqrt(sum(as.numeric(dist_matrix[j,sample_matrix[sample_matrix$cluster!=i,"sample"]]^2)))
      score_tmp=score_intra*10+score_inter/(length(cluster_samples)-1)
      score[score$sample==j,"score"]<-score_tmp
    }
  }
  score$cluster<-sample_matrix[match(score$sample,sample_matrix$sample),"cluster"]
  return(score)
}
