\name{FI}
\alias{FI}
\alias{FI.brm}
\alias{FI.grm}
\title{Calculate Expected and Observed Fisher Information for IRT Models}

\description{
\code{FI} calculates expected and/or observed Fisher information for various
IRT models given a vector of ability values, a vector/matrix of item
parameters, and an IRT model.  It also calculates test
information and expected/observed standard error of measurement.
}

\usage{
FI( params, theta, type = c("expected", "observed"), resp = NULL )
\method{FI}{brm}( params, theta, type = c("expected", "observed"), resp = NULL )
\method{FI}{grm}( params, theta, type = c("expected", "observed"), resp = NULL )
}

\arguments{
  \item{params}{\bold{numeric:} a vector or matrix of item parameters.  If specified
                as a matrix, the rows must index the items, and the columns
                must designate the item parameters.  Furthermore, if calculating
                \emph{expected} information, the number of rows must match the number
                of columns of \command{resp}.  The class of \command{params} must match
                the model: either \option{"brm"} or \option{"grm"}.  For the binary response
                model, \command{params} must either be a 3-dimensional vector or a 3-column
                matrix.  See \bold{Details} for more information.
}
  \item{theta}{\bold{numeric:} a vector of ability values, one for each simulee.  If calculating
               \emph{expected} information, the length of \command{theta} must match
               the number of rows of \command{resp}, unless \command{theta} is a scalar,
               in which case \command{resp} could also be a vector of length
               \code{nrow(params)}.
}
  \item{type}{\bold{character:} a character string indicating the type of information, either
              \option{"expected"} or \option{"observed"}.  For the 1-parameter and
              2-parameter binary response model (of class \option{"brm"} with the
              third column of \command{params} set to 0), both \option{"expected"}
              and \option{"observed"} information are identical. See \bold{Details}
              for more information.
}
  \item{resp}{\bold{numeric:} either a \eqn{N \times J} matrix (where \eqn{N} indicates the
              number of simulees and \eqn{J} indicates the number of items), a
              \eqn{N} length vector (if there is only one item) or a \eqn{J} length
              vector (if there is only one simulee).  For the binary response model
              (\option{"brm"}), \command{resp} must solely contain 0s and 1s.  For the
              graded response model (\option{"grm"}), \command{resp} must solely contain
              integers \eqn{1, \ldots, K}, where \eqn{K} is the number of categories, as
              indicated by the dimension of \command{params}.
}
}

\details{
The function \code{FI} returns item information, test information, and standard error
of measurement for the binary response model (\option{"brm"}) or the graded response
model (\option{"grm"}).  If the log likelihood is twice differentiable, expected Fisher
information is the negative, expected, second derivative of the log likelihood with respect
to the parameter. For the binary response model, expected item information simplifies to the
following:

\deqn{ I(\theta_i | a_j, b_j, c_j) = \frac{\left(\frac{\partial p_{ij}}{\partial \theta_i}\right)^2}{p_{ij}(1 - p_{ij})} }{
       I(\theta_i | a_j, b_j, c_j) = (p_{ij}^{\prime})^2/(p_{ij}(1 - p_{ij})) }

where \eqn{\partial p_{ij}/\partial \theta_i}{p_{ij}^{\prime}} is the partial derivative
of \eqn{p_{ij}} with respect to \eqn{\theta}, and \eqn{p_{ij}} is the probability of response, as
indicated in the help page for \code{\link{simIrt}}.

For the graded response model, expected item information simplifies to the following:

\deqn{ I(\theta_i | a_j, b_{j1}, \ldots, b_{j(k - 1)}) = \sum_k\frac{\left(\frac{\partial P_{ijk}}{\partial \theta_i}\right)^2}{P_{ijk}}}{
       I(\theta_i | a_j, b_{j1}, \ldots, b_{j(k - 1)}) = \sum_k[(P_{ijk}^{\prime})^2/P_{ijk}]}

where \eqn{\partial P_{ijk}/\partial \theta_i}{P_{ijk}^{\prime}} is the partial derivative
of \eqn{P_{ijk}} with respect to \eqn{\theta}, and \eqn{P_{ijk}} is the probability of responding
in category k as indicated in the help page for \code{\link{simIrt}}. See van der Linden and Pashley
(2010).

Observed information is the negative second derivative of the log-likelihood.  For the binary
response model (\option{"brm"}) with 2-parameters (such that the third column of the
parameter matrix is set to 0), observed and expected information are identical because the second
derivative of their log-likelihoods do not contain observed data.  See Baker and Kim (2004),
pp. 66 -- 69.

For all models, test information is defined as the following:

\deqn{ T(\theta_i) = \sum_jI_j(\theta_i) }

where \eqn{I(\theta_i)_j} is shorthand for Fisher information of simulee \eqn{i} on item \eqn{j}.
Finally, the standard error of measurement (SEM) is the inverse, square-root of test information.
\code{FI} is frequently used to \emph{select} items in a CAT and to estimate the precision
of \eqn{\hat{\theta}_i} after test termination.
}

\value{
\code{FI}, \code{FI.brm}, and \code{FI.grm} return a list of the following elements:
  \item{item}{either: (1) a \eqn{N \times J} matrix of item information for each simulee to
              each item; (2) a \eqn{J}-length vector of item information for one simulee to
              each item; or (3) an \eqn{N}-length vector of item information for all simulees
              to one item, depending on the dimensions of \command{params} and \command{theta}.
}
  \item{test}{an \eqn{N}-length vector of test information, one for each simulee. Test
              information is the sum of item information across items.  See \bold{Details} for
              more information.
}
  \item{sem}{an \eqn{N}-length vector of expected or observed standard error of measurement
             for each simulee, which is the inverse-square-root of test information.
             See \bold{Details} for more information.
}
  \item{type}{either \option{"observed"} or \option{"expected"}, indicating the \emph{type}
              of information calculated.
}
}

\references{
Baker, F. B., & Kim, S.-H.  (2004).  \emph{Item Response Theory: Parameter Estimation Techniques, Second Edition}.  New York, NY: Marcel Dekker, Inc.

Dodd, B. G., De Ayala, R. J., & Koch, W. R.  (1995).  Computerized adaptive testing with polytomous items.  \emph{Applied Psychological Measurement}, \emph{19}, 5 -- 22.

Embretson, S. E., & Reise, S. P.  (2000).  \emph{Item Response Theory for Psychologists}.  Mahway, NJ: Lawrence Erlbaum Associates.

Kullback, S., & Leibler, R. A.  (1951).  On information and sufficiency.  \emph{The Annals of Mathematical Statistics}, \emph{22}, 79 -- 86.

van dr Linden, W. J. & Pashley, P. J.  (2010).  Item selection and ability estimation in adaptive testing.  In W. J. van der Linden & C. A. W. Glas (Eds.), \emph{Elements of Adaptive Testing}.  New York, NY: Springer.
}

\author{
Steven W. Nydick \email{nydic001@umn.edu}
}

\seealso{
\code{\link{catIrt}}, \code{\link{KL}}, \code{\link{simIrt}}
}

\examples{
#########################
# Binary Response Model #
#########################

## 1 ##
set.seed(888)
# generating random theta:
theta <- rnorm(20)
# generating an item bank under a 2-parameter binary response model:
b.params <- cbind(a = runif(100, .5, 1.5), b = rnorm(100, 0, 2), c = 0)
# simulating responses using random theta:
b.mod <- simIrt(params = b.params, theta = theta, mod = "brm")

# you can indicate class of params or extract it from simIrt object:
class(b.params) <- "brm"

# calculating expected and observed information:
e.info <- FI(params = b.params, theta = theta, type = "expected")
o.info <- FI(params = b.params, theta = theta, type = "observed", resp = b.mod$resp)

# 2-parameter model, so e.info will be equal to o.info:
all(signif(e.info$item) == signif(o.info$item))


## 2 ##
# generating an item bank under a 3-parameter binary response model:
b.params2 <- cbind(a = runif(100, .5, 1.5), b = rnorm(100, 0, 2), c = .2)
# simulating responses using pre-specified thetas:
b.mod2 <- simIrt(params = b.params2, mod = "brm")

# calculating expected and observed information:
# (if you don't indicate class, you can extract from simIrt object)
e.info2 <- FI(params = b.params2, theta = b.mod2$theta, type = "expected")
o.info2 <- FI(params = b.params2, theta = b.mod2$theta, type = "observed",
                                  resp = b.mod2$resp)

# 3-parameter model, so e.info will not be equal to o.info:
all(signif(e.info2$item) == signif(o.info2$item))


## 3 ##
# if theta is a scalar, item will be a vector and test will be a scalar:
e.info3 <- FI(params = b.params2, theta = 0, type = "expected")
dim(e.info3$item)       # no dimension because it's a vector
length(e.info3$item)    # of length equal to the number of items

# if params is a vector, item will be a matrix with one row:
e.info4 <- FI(params = c(1, 2, 0), theta = c(1, 2), type = "expected")
dim(e.info4$item)

# if you don't class params, FI will assume a binary response model.


#########################
# Graded Response Model #
#########################
set.seed(999)
# generating random theta
theta <- rnorm(10)
# generating an item bank under a graded response model:
g.params <- cbind(a = runif(30, .5, 1.5), b1 = rnorm(30), b2 = rnorm(30),
                                          b3 = rnorm(30), b4 = rnorm(30))
# you can sort the parameters yourself:
g.params <- cbind(g.params[ , 1],
                  t(apply(g.params[ ,2:dim(g.params)[2]], MARGIN = 1,
                                                          FUN = sort)))
# simulating responses using random theta:
g.mod <- simIrt(params = g.params, theta = theta, mod = "grm")

# calculating expected and observed information:
class(g.params) <- "grm"   # always indicate model or extract from simulation.
e.info5 <- FI(params = g.params, theta = theta, type = "expected")
o.info5 <- FI(params = g.params, theta = theta, type = "observed", resp = g.mod$resp)

# grm, so e.info will not be equal to o.info:
all(signif(e.info5$item) == signif(o.info5$item))

# if thet is a vector and params is a vector, item will be a J x N matrix:
dim(e.info5$item)

# if you don't want to sort the parameters, you can extract from simIrt object:
e.info6 <- FI(params = g.mod$params[ , -1], theta = g.mod$theta, type = "expected")

# but you first need to remove column 1 (the item number column).
}
