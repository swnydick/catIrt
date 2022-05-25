#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
 Check these declarations against the C/Fortran source code.
 */

/* .Call calls */
extern SEXP pbrm(SEXP, SEXP);
extern SEXP pder1brm(SEXP, SEXP);
extern SEXP pder1grm(SEXP, SEXP);
extern SEXP pder2brm(SEXP, SEXP);
extern SEXP pder2grm(SEXP, SEXP);
extern SEXP pgrm(SEXP, SEXP);
extern SEXP simPoly(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"pbrm",     (DL_FUNC) &pbrm,     2},
  {"pder1brm", (DL_FUNC) &pder1brm, 2},
  {"pder1grm", (DL_FUNC) &pder1grm, 2},
  {"pder2brm", (DL_FUNC) &pder2brm, 2},
  {"pder2grm", (DL_FUNC) &pder2grm, 2},
  {"pgrm",     (DL_FUNC) &pgrm,     2},
  {"simPoly",  (DL_FUNC) &simPoly,  2},
  {NULL, NULL, 0}
};

void R_init_catIrt(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}