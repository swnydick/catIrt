/* These functions are designed to calulate (brm)
 * -- probabilities
 * -- d1 of probabilities
 * -- d2 of probabilities
 */

/* Note: See R code for all equations */

#include <R.h>
#include <Rinternals.h>
#include <stdio.h>
#include <math.h>

/* Define getDims to make it way easier to get the dimensions of matrices */
#define getDims( A ) INTEGER( coerceVector( getAttrib( A, R_DimSymbol ), INTSXP ) )


/********************/
/* I. PROBABILITIES */
/********************/
SEXP pbrm( SEXP theta, SEXP params )    /* the person and item parameters */
{

/* 1) create scalars in C to hold temporary numbers */
  int n_ppl, n_it;                 /* for the item, person, and dimension numvwea */

  double p_exp;                    /* for the exponent of the dimension probability */

  int i, j;                        /* for the loop iteration */

/* 2)
 *    a) digest the datastructures from R into C */
  int *dimPar;
  double *ptheta, *ppar;           /* pointers to theta and params */

/*    b) get the dimensions of thet and param */
  dimPar = getDims( params );

  n_ppl = length( theta );
  n_it  = dimPar[ 0 ];

/*    c) protect the R objects */
  PROTECT( theta  = coerceVector( theta,  REALSXP ) );
  PROTECT( params = coerceVector( params, REALSXP ) );

/*    d) point to the R objects */
  ptheta = REAL( theta ); ppar = REAL( params );

/* 3)
 *    a) create P (and a pointer) to hold the probability */
  SEXP P;
  double *pP;

/*    b) make sure to allocate space for the vector/matrix */
  if( n_ppl == 1 ){
    PROTECT( P = allocVector( REALSXP, n_it ) );
  } else{
    PROTECT( P = allocMatrix( REALSXP, n_ppl, n_it ) );
  }

  pP = REAL( P );

/*    c) calculate probability of within categories */
  for( i = 0; i < n_ppl; i++ ){
    for( j = 0; j < n_it; j++ ){

/* Note (IMPORTANT) - it fills in by COLUMNS, just like the default in R: */
      
/* calculating the probability of response for one person */
      p_exp               = exp( -ppar[ 0 * n_it + j ] * ( ptheta[ i ] - ppar[ 1 * n_it + j ] ) );

      pP[ j * n_ppl + i ] = ppar[ 2 * n_it + j ] + ( 1 - ppar[ 2 * n_it + j ] ) / ( 1 + p_exp );

    }
  }

/* wrap up and return the result to R */
  UNPROTECT( 3 );

  return( P );

}


/***********************************/
/* II. DERIVATIVE OF PROBABILITIES */
/***********************************/
SEXP pder1brm( SEXP theta, SEXP params )    /* the person and item parameters */
{

/* 1) create scalars in C to hold temporary numbers */
  int n_ppl, n_it;                  /* for the item, person, and dimension numvwea */

  double p_exp;                     /* for the exponent of the dimension probability */
  double p;                         /* for the 2PL probability of correct */

  int i, j;                         /* for the loop iteration */

/* 2)
 *    a) digest the datastructures from R into C */
  int *dimPar;
  double *ptheta, *ppar;           /* pointers to theta and params */

/*    b) get the dimensions of thet and param */
  dimPar = getDims( params );

  n_ppl = length( theta );
  n_it  = dimPar[ 0 ];

/*    c) protect the R objects */
  PROTECT( theta  = coerceVector( theta,  REALSXP ) );
  PROTECT( params = coerceVector( params, REALSXP ) );

/*    d) point to the R objects */
  ptheta = REAL( theta ); ppar = REAL( params );

/* 3)
 *    a) create Pd1 (and a pointer) to hold the derivative */
  SEXP Pd1;
  double *pPd1;

/*    b) make sure to allocate space for the matrix */
  if( n_ppl == 1 ){
    PROTECT( Pd1 = allocVector( REALSXP, n_it ) );
  } else{
    PROTECT( Pd1 = allocMatrix( REALSXP, n_ppl, n_it ) );
  }

  pPd1 = REAL( Pd1 );

/*    c) calculate derivative of probability of within categories */
  for( i = 0; i < n_ppl; i++ ){
    for( j = 0; j < n_it; j++ ){

/* Note (IMPORTANT) - it fills in by COLUMNS, just like the default in R: */
      
/* calculating the derivative of the probability of response for one person */
      p_exp                 = exp( -ppar[ 0 * n_it + j ] * ( ptheta[ i ] - ppar[ 1 * n_it + j ] ) );
      p                     = 1 / ( 1 + p_exp );

      pPd1[ j * n_ppl + i ] = ( 1 - ppar[ 2 * n_it + j ] ) * ppar[ 0 * n_it + j ] * p * ( 1 - p );

    }
  }

/* wrap up and return the result to R */
  UNPROTECT( 3 );

  return( Pd1 );

}


/*******************************************/
/* III. SECOND DERIVATIVE OF PROBABILITIES */
/*******************************************/
SEXP pder2brm( SEXP theta, SEXP params )    /* the person and item parameters */
{

/* 1) create scalars in C to hold temporary numbers */
  int n_ppl, n_it;                  /* for the item, person, and dimension numvwea */

  double p_exp;                     /* for the exponent of the dimension probability */
  double p, p_der1;                 /* for the 2PL probability of correct */

  int i, j;                         /* for the loop iteration */

/* 2)
 *    a) digest the datastructures from R into C */
  int *dimPar;
  double *ptheta, *ppar;           /* pointers to theta and params */

/*    b) get the dimensions of thet and param */
  dimPar = getDims( params );

  n_ppl = length( theta );
  n_it  = dimPar[ 0 ];

/*    c) protect the R objects */
  PROTECT( theta  = coerceVector( theta,  REALSXP ) );
  PROTECT( params = coerceVector( params, REALSXP ) );

/*    d) point to the R objects */
  ptheta = REAL( theta ); ppar = REAL( params );

/* 3)
 *    a) create Pd1 (and a pointer) to hold the derivative */
  SEXP Pd2;
  double *pPd2;

/*    b) make sure to allocate space for the matrix */
  if( n_ppl == 1 ){
    PROTECT( Pd2 = allocVector( REALSXP, n_it ) );
  } else{
    PROTECT( Pd2 = allocMatrix( REALSXP, n_ppl, n_it ) );
  }

  pPd2 = REAL( Pd2 );

/*    c) calculate second derivative of probability of within categories */
  for( i = 0; i < n_ppl; i++ ){
    for( j = 0; j < n_it; j++ ){

/* Note (IMPORTANT) - it fills in by COLUMNS, just like the default in R: */
      
/* calculating the derivative2 of the probability of response for one person */
      p_exp    = exp( ppar[ 0 * n_it + j ] * ( ptheta[ i ] - ppar[ 1 * n_it + j ] ) );
      p        = p_exp / ( 1 + p_exp );
      p_der1   = ( 1 - ppar[ 2 * n_it + j ] ) * ppar[ 0 * n_it + j ] * p * ( 1 - p );

      pPd2[ j * n_ppl + i ] = ppar[ 0 * n_it + j ] * ( 1 - p_exp ) * ( 1 - p ) * p_der1;
    }
  }


/* wrap up and return the result to R */
  UNPROTECT( 3 );

  return( Pd2 );

}
