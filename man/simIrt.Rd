\name{simIrt}
\alias{simIrt}
\title{Simulate Responses to IRT Models}
\description{
\code{simIrt} simulates responses to various IRT models given a vector of ability
values and a vector/matrix of item parameters.
}

\usage{
simIrt( theta = seq(-3, 3, by = 0.1), params, mod = c("brm", "grm") )
}

\arguments{
  \item{theta}{\bold{numeric:} a vector of ability values, one for each
               simulee.
}
  \item{params}{\bold{numeric:} a vector or matrix of item parameters.  If specified as
               a matrix, the rows must index the items, and the columns
               must designate the item parameters.  For the binary response model,
               (\option{"brm"}), \command{params} must either be a 3-element vector
               or a 3-column matrix.  See \bold{Details} for more information.
}
  \item{mod}{\bold{character:} a character string indicating the IRT model.  Current support
             is for the 3-parameter binary response model (\option{"brm"}),
             and Samejima's graded response model (\option{"grm"}).  The contents
             of \command{params} must match the designation of \command{mod}.  See
             \bold{Details} for more information.
}
}

\details{
The function \code{simIrt} returns a response matrix of class "brm" or "grm" depending
on the model.  For the binary response model, the probability of endorsing item \eqn{j}
for simulee \eqn{i} is the following (Embretson & Reise, 2000):

\deqn{ p_{ij} = Pr(u_{ij} = 1 | \theta_i, a_j, b_j, c_j) = c_j + (1 - c_j)\frac{1}{1 + \exp[-a(\theta - b)]} }{
       p_{ij} = c_j + (1 - c_j)/(1 + \exp[-a(\theta - b)]) }

For the graded response model, the probability of endorsing at or above boundary \eqn{k}
of item \eqn{j} for simulee \eqn{i} is the following:

\deqn{ p_{ijk} = Pr(u_{ij} \geq k | \theta_i, a_j, b_k) = \frac{1}{1 + \exp[-a(\theta - b_k)]} }{
       p_{ijk} = 1/(1 + \exp[-a(\theta - b_k)]) }

so that the probability of scoring \emph{in} category \eqn{k} is,
\eqn{P_{ijk} = Pr(u_{ij} = k | \theta_i, a_j, \boldsymbol{b}) = 1 - p_{ijk}} if \eqn{k = 1};
\eqn{p_{ijk}} if \eqn{k = K}; and \eqn{p_{ij(k - 1)} - p_{ijk}} otherwise, where \eqn{K}
is the number of categories, so that \eqn{K - 1} is the number of boundaries.

Assuming perfect model fit, \code{simIrt} generates the probability of responding in a category,
simulates a random, uniform deviate, and compares the probability of response with the location
of the deviate.  For instance, for the binary response model, if \eqn{p_{ij} = .7}, so that
\eqn{q_{ij} = 1 - p_{ij} = .3}, \code{simIrt} will generate a uniform deviate (\eqn{u_{ij}}) between 0 and 1.  
If \eqn{u_{ij} < p_{ij}}, the simulee will score a 1, and otherwise, the simulee will score a 0.
}

\value{
The function \code{simIrt} returns a list of the following elements:
  \item{resp}{a matrix of class "brm" or "grm" depending on the model used.
              The dimensions of the matrix will be \eqn{N \times J} (persons by items),
              and will contain 0s and 1s for the binary response model or \eqn{1 \ldots K}
              for the graded response model, where \emph{K} indicates the number of categories.
}
  \item{params}{a matrix of class "brm" or "grm" containing the item parameters used 
                in the simulation.  In the case of "grm", the threshold parameters will be
                ordered so that they will work in other functions.
}
  \item{theta}{a vector of theta used in the simulation.  If \command{theta} is not specified
               by the user, it will default to a 201-length vector of evenly spaced points
               between -3 and 3.
}
}

\references{
Embretson, S. E., & Reise, S. P.  (2000).  \emph{Item Response Theory for Psychologists}.  Mahway, NJ: Lawrence Erlbaum Associates.

Samejima, F.  (1969).  Estimation of latent ability using a response pattern of graded scores.  \emph{Psychometrika Monograph Supplement}, \emph{34}, 100 -- 114.

van der Linden, W. J. & Hambleton, R. K.  (2010).  \emph{Handbook of Modern Item Response Theory}.  New York, NY: Springer.
}

\author{
Steven W. Nydick \email{nydic001@umn.edu}
}

\seealso{
\code{\link{catIrt}}
}

\examples{
#########################
# Binary Response Model #
#########################
set.seed(888)
# generating an item bank under a binary response model:
b.params <- cbind(a = runif(100, .5, 1.5), b = rnorm(100, 0, 2), c = .2)
# simulating responses using default theta:
b.mod <- simIrt(params = b.params, mod = "brm")

# same type of model without a guessing (c) parameter:
b.params2 <- cbind(a = runif(100, .5, 1.5), b = rnorm(100, 0, 2), c = 0)
b.mod2 <- simIrt(params = b.params2, mod = "brm")

# now generating a different theta:
theta <- rnorm(201)
b.mod3 <- simIrt(theta = theta, params = b.params2, mod = "brm")

# notice all of the responses are 0 or 1:
unique(as.vector(b.mod$resp))

# and the percentages (in general) increase as theta increases:
apply(b.mod$resp, 1, mean)    # theta = seq(-3, 3, by = 0.1)


#########################
# Graded Response Model #
#########################
set.seed(999)
# generating an item bank under a graded response model:
# (as many categories as your heart desires!)
g.params <- cbind(a = runif(10, .5, 1.5), b1 = rnorm(10), b2 = rnorm(10),
                                          b3 = rnorm(10))
# simulating responses using default theta (automatically sorts boundaries):
g.mod <- simIrt(params = g.params, mod = "grm")

# notice how the old parameters were not sorted:
g.params
# but the new parameters are sorted from column 2 on:
g.mod$params

# don't use these parameters with the binary response model:
try(simIrt(params = g.params, mod = "brm"), silent = TRUE)[1]

# a better parameter set for the graded response model:
g.params2 <- cbind(runif(100, .5, 1.5), b1 = runif(100, -2, -1), b2 = runif(100, -1, 0),
                                        b3 = runif(100, 0, 1), b4 = runif(100, 1, 2))
g.mod2 <- simIrt(params = g.params2, mod = "grm")

# notice all of the responses are positive integers:
unique(as.vector(g.mod$resp))
unique(as.vector(g.mod2$resp))

# and the responses (in general) increase as theta increases:
apply(g.mod2$resp, 1, mean)
}