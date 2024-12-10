prselect<-function(score,n) {
  prselect_matrix<-as.data.frame(matrix("",length(unique(score$cluster)),n+1))
  colnames(prselect_matrix)<-c("cluster",paste0("ref",seq(n)))
  prselect_matrix$cluster<-unique(score$cluster)
  for (i in unique(score$cluster)) {
    tmp_matrix<-score[score$cluster==i,]
    sample_num<-length(tmp_matrix$cluster)
    for (j in 1:n) {
      prselect_matrix[prselect_matrix$cluster==i,1+j]<-tmp_matrix[order(tmp_matrix$score,decreasing = T),][j,"sample"]
    }
  }
  prselect_matrix<-t(prselect_matrix)
  colnames(prselect_matrix)<-as.character(prselect_matrix[1,])
  prselect_matrix<-prselect_matrix[-1,]
  return(prselect_matrix)
}
