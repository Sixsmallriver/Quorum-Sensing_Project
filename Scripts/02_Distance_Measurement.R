#title           : make_categories.R
#description     : Clusters cells into groups\colonies and calculates the distance of each cell to the edge of a colony
#author          : Tobias Wechsler
#date            : 2021/03/01
#version         : 
#usage           : 
#notes           :
#R_version       :
#=======================================================================================================================

library(ggplot2)
library(tidyr)
library(plyr)
library(dplyr)
library(alphahull)




# Calculate the distance of a point to a linesegment
getDist2Line <- function(x0, y0, x1, y1, x2, y2){
  distance = rep(NA, length(x0))
  
  v = as.vector(c(x1,y1))
  w = as.vector(c(x2,y2))
  l2 = (y2-y1)**2 + (x2-x1)**2
  
  for (i in 1:length(distance)){
    p = as.vector(c(x0[i],y0[i]))
    
    t = max(0, min(1, ((p-v)%*%(w-v))/l2))
    pp = v + t * (w - v)
    distance[i] = sqrt( (pp[1]-p[1])^2 + (pp[2]-p[2])^2)
    
  }
  return(distance)
}


# Determines cells on the edge of the colony and returns the distance to the edge of every cell
getDist <-function(x,y){
  temp = data.frame(x=x,y=y)
  
  temp$dist.to.edge = 0
  
 
  hull = tryCatch(ahull(temp, alpha=30), error=function(e) list())
  
  if (length(hull)==0){
    temp$dist.to.edge = 0
    return(temp$dist.to.edge)
  }
  if (sum(hull$ashape.obj$alpha.extremes) == length(x)){
    temp$dist.to.edge = 0
    return(temp$dist.to.edge)
  } else {
    temp[hull$ashape.obj$alpha.extremes,]$edge = TRUE
    edg = data.frame(hull$ashape.obj$edges)
    old.dists = getDist2Line(temp$x, temp$y,
                             edg[1,'x1'], edg[1,'y1'],
                             edg[1,'x2'], edg[1,'y2'])
    
    for (l in 1:nrow(edg)){
      dists = getDist2Line(temp$x, temp$y,
                           edg[l,'x1'], edg[l,'y1'],
                           edg[l,'x2'], edg[l,'y2'])
      smlr = dists < old.dists
      old.dists[smlr & !is.na(smlr)] = dists[smlr & !is.na(smlr)]

    }
    
    return(old.dists)
    
  }
}

filename = '../Data/Cluster_Results/lasB_with_delta_results_clustered_cleaned_2.csv'
 
data<-read.csv(filename, header=T, stringsAsFactors=TRUE);names(data)


# Show results of clustering
print(unique(data$cluster))
# chose one cluster to show cluster results
data.cluster <- data %>% filter(cluster == 46)
t.snap = c(min(data.cluster$frames), floor(max(data.cluster$frames)/4), floor(max(data.cluster$frames)/2), floor(max(data.cluster$frames)*3/4), max(data.cluster$frames))
ggplot(filter(data.cluster, frames %in% t.snap), aes(x=new_x, y=new_y, color=as.factor(Group))) + geom_point() + facet_grid(~frames)

# Calculate the distance to the edge
data.dist = plyr::ddply(data, .(frames, cluster), mutate, dist.to.edge=getDist(new_x,new_y))
data.dist$edge = FALSE
data.dist[which(data.dist$dist.to.edge==0), 'edge'] = TRUE

# # check
# data.3 <- data %>% filter(cluster == 88)
# data.4 <- data.3 %>% filter(frames == 35)
# data.5 = data.4 %>% mutate(dist.to.edge = getDist(new_x, new_y)) 
# ggplot(dplyr::filter(data.5, frames == 21)) +
#   geom_point(aes(x=new_x, y=new_y, color=dist.to.edge, shape=edge)) +
#   labs(x = "X Position", y = "Y Position", color = "Distance to Edge", shape = "Edge Type") +
#   theme_minimal()


# Show cell position from beginning, middle and end
data.after <- data.dist %>% filter(cluster == 47)
t.snap = c(min(data.after$frames), floor(max(data.after$frames)/2), max(data.after$frames))

ggplot(dplyr::filter(data.after, frames %in% t.snap)) +
  geom_point(aes(x=new_x, y=new_y, color=fluo2, shape = edge)) + facet_grid(~frames)


# save the file
output_dir <- "../Data/Distance_Results/" 

# make sure the output dir exist
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

file_base <- tools::file_path_sans_ext(basename(filename))
output_path <- file.path(output_dir, paste0(file_base, "_distance.csv"))

write.csv(data.dist, output_path)
