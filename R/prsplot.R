#' Title
#'
#' @param dist_matrix the distance matrix produced by VCF2Dis
#' @param sample_matrix sample matrix with sample column and cluster column
#' @param picked_samples matrix produced by prselect
#' @param type pcoa or representative [default: pcoa]
#' @param label logical: TRUE or FALSE
#' @param axis1 charactar Axis.1,Axis.2,Axis.3... [default: Axis.1]
#' @param axis2 charactar Axis.1,Axis.2,Axis.3... [default: Axis.2]
#'
#' @return 0
#' @export
#'
#' @importFrom ape pcoa
#' @importFrom ggplot2 ggplot aes geom_point geom_hline geom_vline labs geom_label theme_bw
#' @importForm tidyr gather
#'
#' @examples
#' prsplot(dist_matrix,sample_matrix,picked_samples)

prsplot<-function(dist_matrix,sample_matrix,picked_samples,type="pcoa",label=TRUE,axis1="Axis.1",axis2="Axis.2"){
  pcoa_result <- pcoa(dist_matrix)
  plot_input<-as.data.frame(pcoa_result$vectors)
  colnames(sample_matrix)<-c("sample","cluster")
  plot_input$cluster<-sample_matrix[match(rownames(plot_input),sample_matrix$sample),"cluster"]
  a1 <- plot_input[,axis1]
  a2 <- plot_input[,axis2]
  if (type=="pcoa") {
    ggplot(plot_input, aes(a1, a2,fill = cluster))+
      # 选择X轴Y轴并映射颜色和形状
      geom_point(size = 3,color="black",shape=21)+
      geom_hline(yintercept = 0,linetype="dashed") +
      geom_vline(xintercept = 0,linetype="dashed") +
      labs(x = axis1, y = axis2)+
      theme_bw()
  } else if(type=="representative"){
    picked_tmp<-gather(as.data.frame(picked_samples), key = "cluster",
                       value = "sample")
    rp_plot_input<-plot_input[picked_tmp$sample,]
    rp_plot_input$id<-rownames(rp_plot_input)
    p1<-ggplot()+
      # 选择X轴Y轴并映射颜色和形状
      geom_point(data = plot_input, aes(a1, a2),fill = "white",size = 3,color="black",shape=21)+
      geom_hline(yintercept = 0,linetype="dashed") +
      geom_vline(xintercept = 0,linetype="dashed") +
      labs(x = axis1, y = axis2)+
      theme_bw()
    p<-p1
    b1 <- rp_plot_input[,axis1]
    b2 <- rp_plot_input[,axis2]
    if(label==TRUE){
      p<-p1 + geom_point(data = rp_plot_input,aes(b1,b2,fill=cluster),size = 3,color="black",shape=21)+
        geom_label(aes(b1,b2,label = id), data=rp_plot_input, nudge_y = 0.01,alpha = 0.5)
    } else {
      p<-p1 + geom_point(data = rp_plot_input,aes(b1,b2,fill=cluster),size = 3,color="black",shape=21)
    }
  } else {
    break
  }
}
