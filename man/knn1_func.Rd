\name{knn1_func}
\alias{knn1_func}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
knn1_func
}
\description{
Nearest Neighbor classification on the test set based on the training set and the known labels for the training set. Note that the nearest neighbor is found based on Euclidean distance.
}
\usage{
knn1_func(train, test, cl)
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
}
\details{
There should not be NA's in the input 'train', 'test', or 'cl' arguments. If there are NA's introduced, the function would return an error message.
}
\value{
Factor of classification results of the test set. If there are more than 1 observations in the training set have the smallest distance between the test case, 1 of the labels of these observations is chosen as the classification result by random.
}
\references{
knn1 function in library(class)
}
\author{
Yiwen Chen
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\examples{

knn1_func <- function(train, test, cl){
  if(sum(is.na(train))!=0){
    stop("no missing values are allowed")
  }
  if(sum(is.na(test))!=0){
    stop("no missing values are allowed")
  }
  if(sum(is.na(cl))!=0){
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

  find_nearest_1 <- function(dists){
    smallest_dist <- min(dists)

    ind_nearest_k <- which(dists %in% smallest_dist)
    if(length(ind_nearest_k)!=1){
      ind_nearest_k<- sample(ind_nearest_k,1)
    }
    nearest <- cl[ind_nearest_k]
    return (nearest)
  }

  if(n_test==1){ #the input test case is a row vector
    distances_vec <- outer(1, 1:n_train, vdis)

    class_result <- find_nearest_1(distances_vec)
    return (class_result)

  }
  else{#the input test case is a matrix with multiple observations
    distances_mat <- outer(1:n_test, 1:n_train, vdis) #each row i corresponds to distances of that test case i to all points in training test

    class_result <- apply(distances_mat,1,find_nearest_1)
    return (class_result)
  }


}




train <- matrix(c(9,1,2,3,9,0,1,9,9,8,2,3,6,9,4,2,3,6),ncol=2)
test <- matrix(c(2,9,3,8),ncol=2)
cl <- as.factor(c("a","b","b","b","c","c","c","c","c"))
knn1_func(train,test,cl)
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
