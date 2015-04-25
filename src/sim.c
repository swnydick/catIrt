/* These functions are designed to simulate responses to
 * -- polytomous item response models
 */

#include <R.h>
#include <Rinternals.h>
#include <stdio.h>
#include <math.h>

/* Define getDims to make it way easier to get the dimensions of matrices */
#define getDims( A ) INTEGER( coerceVector( getAttrib( A, R_DimSymbol ), INTSXP ) )


/* THE FUNCTION TO SIMULATE THE POLYTOMOUS MODEL VALUES */
SEXP simPoly( SEXP prob, SEXP K )         /* a probability matrix and number of categories */
{

/* 1) create scalars in C to hold temporary number */
  int n_ppl, n_it, n_cat;                 /* for the item, person, and category dimensions */

  double p;                               /* for the probability of correct */
  double u;                               /* for the simulated uniform, random number */

  int i, j, k;                            /* for the loop iteration */

/* 2)
 *    a) digest the datastructures from R into C */
  int *dimProb;
  double *pprob, *pK;                     /* pointers to prob matrix and K */

/*    b) get the dimensions of prob */
  dimProb = getDims( prob );

/*    c) protect the R objects */
  PROTECT( prob  = coerceVector( prob,  REALSXP ) );
  PROTECT( K     = coerceVector( K, REALSXP ) );

/*    d) point to the R objects */
  pprob = REAL( prob ); pK = REAL( K );

/*    e) get the dimensions of everything else */
  n_ppl = dimProb[ 0 ] / pK[ 0 ] ;
  n_it  = dimProb[ 1 ];
  n_cat = pK[ 0 ];

/* 3)
 *    a) create sim to hold the answer */
  SEXP sim;
  double *psim;                           /* a pointer to sim */

/*    b) make sure to allocate space for the matrix */
  PROTECT( sim = allocMatrix( REALSXP, n_ppl, n_it ) );
  psim = REAL( sim );

/*    c) get the RNG (random number) state from R */
  GetRNGstate();

/*    d) simulate the response for each person */
  for( i = 0; i < n_ppl; i++ ){
    for( j = 0; j < n_it; j++ ){

      u = unif_rand();           /* random number */
      p = 0;                     /* temp probability */
      psim[ j * n_ppl + i ] = 1; /* initialize to 1 */
      
      for( k = 0; k < n_cat; k++ ){

        p += pprob[ j * n_ppl * n_cat + i * n_cat + k ];

	if( p <= u )
	    psim[ j * n_ppl + i ] = k + 2;

      }
    }
  }

/* put the RNG (random number) state back to R */
  PutRNGstate();

/* wrap up and return the result to R */
  UNPROTECT( 3 );

  return( sim );

}
