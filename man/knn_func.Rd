\name{knn_func}
\alias{knn_func}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
knn_func
}
\description{
This function uses K-nearest neighbor classification on the input test cases based on the input training set and cl(labels for the training set). For each observation of the test cases, the k nearest training set vectors are found, and the classification result is based on the majority vote. Note that the k nearest observations are found based on Euclidean distance.
}
\usage{
knn_func(train, test, cl, k, prob=FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{train}{
  The input training dataset (as a form of a matrix).
}
  \item{test}{
  The input vector or matrix that is to be classified by the KNN algorithm.
}
  \item{cl}{
  The vector(or factor) containing labels for the training dataset. The length of this argument should match with the row numbers of the training dataset.
}
  \item{k}{
  The input argument k that performs KNN algorithm. k is ideally chosen to be an odd number.
}
  \item{prob}{
  The argument that determines whether the output contains attribute of the proportion of votes for the winning.
}
}
\details{
There should not be NA's in the input 'train', 'test', 'cl', or 'k' arguments. If there are NA's introduced, the function would return an error message.
}
\value{
Factor of classification results of the test set. If the argument 'prob' is set to be 'TRUE', then the proportions of the winning votes are returned as the attribute of the factor.
}
\references{
knn function in library(class)
}
\author{
Yiwen Chen
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
## The function is currently defined as
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

  distance <- function(a,b){ #a and b are indices of observations,
  #a corresponds to the ath row of test dataset, b corresponds to the bth row of the train dataset
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
    ind_nearest_k <- which(dists \%in\% smallest_k_dists)
    k_nearest <- cl[ind_nearest_k]
    tab <- table(k_nearest) #make a table of frequencies for the k nearest observations in train
    freq_max <- max(tab) # find which is the largest frequency
    returned <- names(tab)[which.max(tab)]
    if(prob==FALSE){
      class <- factor(returned, levels=my_levels)
      #return (list(class=class))
      class
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
    distances_mat <- outer(1:n_test, 1:n_train, vdis)
    #each row i corresponds to distances of that test case i to all points in training test


    class_result <- apply(distances_mat,1,find_k_nearest,simplify = FALSE)
    attri_result <- sapply(class_result,function(x){attr(x,'prob')})
    class_result <- (unlist(class_result))
    attributes(class_result)$'prob'<-attri_result
    return (class_result)
  }


}



train <- matrix(c(9,1,2,3,9,0,1,9,9,8,2,3,6,9,4,2,3,6),ncol=2)
test <- matrix(c(2,9,3,8),ncol=2)
cl <- as.factor(c("a","b","b","b","c","c","c","c","c"))
knn_func(train,test,cl,prob=TRUE,k=5)

}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
