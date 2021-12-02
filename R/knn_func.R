knn_func <- function(train, test, cl, k, prob=FALSE){ #l=0 in the original knn function
  if(sum(is.na(train))!=0){
    stop("no missing values are allowed")
  }
  if(sum(is.na(test))!=0){
    stop("no missing values are allowed")
  }
  if(sum(is.na(cl))!=0){
    stop("no missing values are allowed")
  }
  if(is.na(k)){
    stop("no missing values are allowed")
  }
  cl <- factor(cl)
  my_levels <- levels(cl)

  if(is.null(dim(test))){
    test <- t(matrix(test))
  }

  n_test <- nrow(test)
  n_train <- nrow(train)

  distance <- function(a,b){ #a and b are indices of observations, a corresponds to the ath row of test dataset, b corresponds to the bth row of the train dataset
    if(n_test==1){
      diff <- test-train[b,]
      euc_dis <- (sqrt(sum(diff^2)))
      return (euc_dis)
    }
    else{
      diff <- test[a,]-train[b,]
      euc_dis <- (sqrt(sum(diff^2)))
      return (euc_dis)
    }
  }

  vdis <- Vectorize(distance) #make a customized distance function that can do vectorized operations

  find_k_nearest <- function(dists){
    sorted <- sort(dists, decreasing=FALSE)
    smallest_k_dists <- sorted[1:k]
    ind_nearest_k <- which(dists %in% smallest_k_dists)
    k_nearest <- cl[ind_nearest_k]
    tab <- table(k_nearest) #make a table of frequencies for the k nearest observations in train
    freq_max <- max(tab) # find which is the largest frequency
    returned <- names(tab)[which.max(tab)]
    if(prob==FALSE){
      class <- factor(returned, levels=my_levels)
      #return (list(class=class))
      return (class)
    }
    else{
      class <- factor(returned, levels=my_levels)
      attributes(class)$"prob" <- as.vector(tab[class])/sum(tab)
      return (class)
    }

  }

  if(n_test==1){ #the input test case is a row vector
    distances_vec <- outer(1, 1:n_train, vdis)

    class_result <- find_k_nearest(distances_vec)
    return (class_result)
  }
  else{#the input test case is a matrix with multiple observations
    distances_mat <- outer(1:n_test, 1:n_train, vdis) #each row i corresponds to distances of that test case i to all points in training test

    if(prob==FALSE){
      class_result <- apply(distances_mat,1,find_k_nearest,simplify = TRUE)
    }
    else{
      class_result <- apply(distances_mat,1,find_k_nearest,simplify = FALSE)
      attri_result <- sapply(class_result,function(x){attr(x,'prob')})
      class_result <- (unlist(class_result))
      attributes(class_result)$'prob'<-attri_result
    }
    return (class_result)
  }


}
