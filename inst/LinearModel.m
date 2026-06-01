## Copyright (C) 2026 Avanish Salunke <avanishsalunke16@gmail.com>
##
## This file is part of the statistics package for GNU Octave.
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

classdef LinearModel

  properties (GetAccess = public, SetAccess = protected)

    ## Coefficient estimate properties

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} CoefficientCovariance
    ##
    ## Covariance matrix of coefficient estimates
    ##
    ## A @math{p}-by-@math{p} numeric matrix of covariance values for the
    ## coefficient estimates, where @math{p} is the number of coefficients in
    ## the fitted model as given by @code{NumCoefficients}.  This property is
    ## read-only.
    ##
    ## @end deftp
    CoefficientCovariance = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} CoefficientNames
    ##
    ## Coefficient names
    ##
    ## A cell array of character vectors, each containing the name of the
    ## corresponding model term (e.g., @qcode{'(Intercept)'}, @qcode{'x1'},
    ## @qcode{'x1:x2'}).  This property is read-only.
    ##
    ## @end deftp
    CoefficientNames = {};

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Coefficients
    ##
    ## Coefficient values
    ##
    ## A table with one row for each coefficient and four columns:
    ## @itemize
    ## @item @code{Estimate} - estimated coefficient value
    ## @item @code{SE} - standard error of the estimate
    ## @item @code{tStat} - t-statistic for a two-sided test
    ## @item @code{pValue} - p-value for the t-statistic
    ## @end itemize
    ## Coefficients that are dropped due to rank deficiency have
    ## @code{Estimate = 0}, @code{SE = 0}, @code{tStat = NaN},
    ## @code{pValue = NaN}.  This property is read-only.
    ##
    ## @end deftp
    Coefficients = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} NumCoefficients
    ##
    ## Number of model coefficients
    ##
    ## A positive integer giving the total number of coefficients in the fitted
    ## model, including any coefficients set to zero because the model terms are
    ## rank deficient.  This property is read-only.
    ##
    ## @end deftp
    NumCoefficients = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} NumEstimatedCoefficients
    ##
    ## Number of estimated coefficients
    ##
    ## A positive integer giving the number of coefficients actually estimated,
    ## i.e., not set to zero due to rank deficiency.
    ## @code{NumEstimatedCoefficients} equals the degrees of freedom for
    ## regression.  This property is read-only.
    ##
    ## @end deftp
    NumEstimatedCoefficients = [];

    ## Summary statistic properties

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} DFE
    ##
    ## Degrees of freedom for error
    ##
    ## A positive integer equal to the number of observations minus the number
    ## of estimated coefficients: @code{DFE = NumObservations -
    ## NumEstimatedCoefficients}.  This property is read-only.
    ##
    ## @end deftp
    DFE = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Diagnostics
    ##
    ## Observation diagnostics
    ##
    ## A table with one row per observation and seven columns:
    ## @itemize
    ## @item @code{Leverage} - diagonal of the hat matrix @math{H}
    ## @item @code{CooksDistance} - Cook's distance, a measure of scaled
    ##   change in fitted values
    ## @item @code{Dffits} - delete-1 scaled differences in fitted values
    ## @item @code{S2_i} - delete-1 residual variance estimate
    ## @item @code{CovRatio} - ratio of the determinant of the coefficient
    ##   covariance matrix with and without each observation
    ## @item @code{Dfbetas} - @math{n}-by-@math{p} matrix of scaled changes
    ##   in coefficient estimates when each observation is deleted in turn
    ## @item @code{HatMatrix} - @math{n}-by-@math{n} projection matrix such
    ##   that @code{Fitted = HatMatrix * y}
    ## @end itemize
    ## Rows not used in fitting have @code{NaN} in @code{CooksDistance},
    ## @code{Dffits}, @code{S2_i}, and @code{CovRatio}, and zeros in
    ## @code{Leverage}, @code{Dfbetas}, and @code{HatMatrix}.  This property
    ## is read-only.
    ##
    ## @end deftp
    Diagnostics = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Fitted
    ##
    ## Fitted response values
    ##
    ## An @math{n}-by-1 numeric vector of predicted response values based on
    ## the training data, where @math{n} is the total number of observations
    ## including excluded and missing rows, which contain @code{NaN}.  Use
    ## @code{predict} to obtain predictions for new data or to compute
    ## confidence bounds.  This property is read-only.
    ##
    ## @end deftp
    Fitted = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} LogLikelihood
    ##
    ## Log-likelihood of the fitted model
    ##
    ## A scalar numeric value equal to the log-likelihood of the response
    ## values, assuming each response is normally distributed with mean equal
    ## to the fitted value and variance equal to @math{SSE/n} (the MLE
    ## variance estimate).  This property is read-only.
    ##
    ## @end deftp
    LogLikelihood = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} ModelCriterion
    ##
    ## Model comparison criteria
    ##
    ## A structure with four fields:
    ## @itemize
    ## @item @code{AIC} - Akaike information criterion:
    ##   @math{-2 * logL + 2 * m}
    ## @item @code{AICc} - AIC corrected for sample size:
    ##   @math{AIC + (2*m*(m+1))/(n-m-1)}
    ## @item @code{BIC} - Bayesian information criterion:
    ##   @math{-2 * logL + m * log(n)}
    ## @item @code{CAIC} - Consistent AIC:
    ##   @math{-2 * logL + m * (log(n) + 1)}
    ## @end itemize
    ## Here @math{logL} is @code{LogLikelihood}, @math{m} is
    ## @code{NumEstimatedCoefficients}, and @math{n} is
    ## @code{NumObservations}.  This property is read-only.
    ##
    ## @end deftp
    ModelCriterion = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} ModelFitVsNullModel
    ##
    ## F-test of the fitted model versus the null model
    ##
    ## A structure with three fields:
    ## @itemize
    ## @item @code{Fstat}- F-statistic of the fitted model versus a null
    ##   model containing only a constant term
    ## @item @code{Pvalue} - p-value for the F-statistic
    ## @item @code{NullModel} - character vector describing the null model
    ## @end itemize
    ## This property is read-only.
    ##
    ## @end deftp
    ModelFitVsNullModel = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} MSE
    ##
    ## Mean squared error
    ##
    ## A scalar numeric value equal to @math{SSE / DFE}, where @code{SSE} is
    ## the sum of squared errors and @code{DFE} is the degrees of freedom for
    ## error.  This property is read-only.
    ##
    ## @end deftp
    MSE = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Residuals
    ##
    ## Residuals for the fitted model
    ##
    ## A table with one row per observation and four columns:
    ## @itemize
    ## @item @code{Raw} - observed minus fitted values
    ## @item @code{Pearson} - raw residuals divided by @code{RMSE}
    ## @item @code{Standardized} - internally studentized residuals; raw
    ##   residuals divided by their estimated standard deviation using the
    ##   full-model @code{MSE}
    ## @item @code{Studentized} - externally studentized residuals; each raw
    ##   residual divided by an estimate of the standard deviation based on
    ##   all observations except that one, using the delete-1 @code{S2_i}
    ## @end itemize
    ## Rows not used in the fit contain @code{NaN}.  This property is
    ## read-only.
    ##
    ## @end deftp
    Residuals = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} RMSE
    ##
    ## Root mean squared error
    ##
    ## A scalar numeric value equal to @math{sqrt(MSE)}.  This property is
    ## read-only.
    ##
    ## @end deftp
    RMSE = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Rsquared
    ##
    ## R-squared goodness-of-fit statistics
    ##
    ## A structure with two fields:
    ## @itemize
    ## @item @code{Ordinary} - coefficient of determination:
    ##   @math{R^2 = SSR / SST}
    ## @item @code{Adjusted} - adjusted @math{R^2} that accounts for the
    ##   number of coefficients in the model
    ## @end itemize
    ## This property is read-only.
    ##
    ## @end deftp
    Rsquared = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} SSE
    ##
    ## Sum of squared errors
    ##
    ## A scalar numeric value equal to the sum of squared residuals.  For a
    ## model with an intercept, @math{SST = SSE + SSR}.  For weighted fits,
    ## this is the weighted sum of squares.  This property is read-only.
    ##
    ## @end deftp
    SSE = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} SSR
    ##
    ## Regression sum of squares
    ##
    ## A scalar numeric value equal to the sum of squared deviations of the
    ## fitted values from the mean of the response.  For a model with an
    ## intercept, @math{SST = SSE + SSR}.  For weighted fits, this is the
    ## weighted sum of squares.  This property is read-only.
    ##
    ## @end deftp
    SSR = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} SST
    ##
    ## Total sum of squares
    ##
    ## A scalar numeric value equal to the sum of squared deviations of the
    ## response from its mean. For a model with an intercept,
    ## @math{SST = SSE + SSR}. For a robust fit, @math{SST = SSE + SSR}
    ## rather than the deviation from the mean. For weighted fits, this is
    ## the weighted sum of squares. This property is read-only.
    ##
    ## @end deftp
    SST = [];


    ## Fitting method properties

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Robust
    ##
    ## Robust fit information
    ##
    ## A structure with three fields:
    ## @itemize
    ## @item @code{WgtFun} - robust weighting function name, e.g.
    ##   @qcode{'bisquare'}
    ## @item @code{Tune} - tuning constant; empty if @code{WgtFun} is
    ##   @qcode{'ols'} or a function handle with the default tuning constant
    ## @item @code{Weights} - vector of final iteration weights; empty for
    ##   a @code{CompactLinearModel} object
    ## @end itemize
    ## This structure is empty unless the model was fit using robust
    ## regression.  This property is read-only.
    ##
    ## @end deftp
    Robust = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Steps
    ##
    ## Stepwise fitting information
    ##
    ## A structure with seven fields:
    ## @itemize
    ## @item @code{Start} - formula string of the starting model
    ## @item @code{Lower} - formula string of the lower-bound model; terms
    ##   listed here cannot be removed
    ## @item @code{Upper} - formula string of the upper-bound model; the
    ##   model cannot grow beyond this
    ## @item @code{Criterion} - criterion used, e.g. @qcode{'sse'}
    ## @item @code{PEnter} - threshold for adding a term
    ## @item @code{PRemove} - threshold for removing a term
    ## @item @code{History} - table with one row per step and columns
    ##   @code{Action}, @code{TermName}, @code{Terms}, @code{DF},
    ##   @code{delDF}, @code{FStat}, @code{PValue}
    ## @end itemize
    ## This structure is empty unless the model was fit using stepwise
    ## regression.  This property is read-only.
    ##
    ## @end deftp
    Steps = [];


    ## Input data properties

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Formula
    ##
    ## Model formula information
    ##
    ## A structure representing the model formula with fields including
    ## @code{ResponseName}, @code{LinearPredictor}, @code{PredictorNames},
    ## @code{TermNames}, @code{HasIntercept}, @code{Terms} (the terms
    ## matrix), and @code{InModel}.  This property is read-only.
    ##
    ## @end deftp
    Formula = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} NumObservations
    ##
    ## Number of observations used in the fit
    ##
    ## A positive integer giving the number of observations actually used in
    ## fitting.  Rows with missing values and rows excluded via the
    ## @code{'Exclude'} name-value argument are not counted.  This property
    ## is read-only.
    ##
    ## @end deftp
    NumObservations = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} NumPredictors
    ##
    ## Number of predictor variables
    ##
    ## A positive integer giving the number of predictor variables used to
    ## fit the model.  This property is read-only.
    ##
    ## @end deftp
    NumPredictors = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} NumVariables
    ##
    ## Number of variables in the input data
    ##
    ## A positive integer giving the total number of variables in the input
    ## data, counting predictors, the response, and any unused columns.
    ## This property is read-only.
    ##
    ## @end deftp
    NumVariables = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} ObservationInfo
    ##
    ## Per-observation metadata
    ##
    ## An @math{n}-by-4 table where @math{n} is the total number of rows in
    ## the input data.  The four columns are:
    ## @itemize
    ## @item @code{Weights} - observation weight, default is 1
    ## @item @code{Excluded} - logical; true if excluded via the
    ##   @code{'Exclude'} argument
    ## @item @code{Missing} - logical; true if the row contains any
    ##   @code{NaN} value
    ## @item @code{Subset} - logical; true if the observation was used in
    ##   the fit, i.e. not excluded and not missing
    ## @end itemize
    ## This property is read-only.
    ##
    ## @end deftp
    ObservationInfo = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} ObservationNames
    ##
    ## Observation names
    ##
    ## A cell array of character vectors containing the names of the
    ## observations.  If the fit was based on a table that has row names,
    ## this property holds those names.  Otherwise it is an empty cell array.
    ## This property is read-only.
    ##
    ## @end deftp
    ObservationNames = {};

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} PredictorNames
    ##
    ## Names of predictor variables
    ##
    ## A cell array of character vectors containing the names of the
    ## predictor variables used to fit the model.  This property is
    ## read-only.
    ##
    ## @end deftp
    PredictorNames = {};

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} ResponseName
    ##
    ## Response variable name
    ##
    ## A character vector containing the name of the response variable.
    ## This property is read-only.
    ##
    ## @end deftp
    ResponseName = '';

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} VariableInfo
    ##
    ## Information about input variables
    ##
    ## A table with one row per variable including any unused variables, and
    ## four columns:
    ## @itemize
    ## @item @code{Class} - variable class as a character vector, e.g.
    ##   @qcode{'double'} or @qcode{'categorical'}
    ## @item @code{Range} - for continuous variables, a two-element vector
    ##   @code{[min, max]}; for categorical variables, a vector of the
    ##   distinct values
    ## @item @code{InModel} - logical; true if the variable is in the
    ##   fitted model
    ## @item @code{IsCategorical} - logical; true if the variable is
    ##   categorical
    ## @end itemize
    ## This property is read-only.
    ##
    ## @end deftp
    VariableInfo = [];

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} VariableNames
    ##
    ## Names of all variables in the input data
    ##
    ## A cell array of character vectors containing the names of all
    ## variables, including predictors, the response, and unused variables.
    ## For table input these are the table column names.  For matrix input
    ## these are the values given by @code{'VarNames'}, defaulting to
    ## @qcode{@{'x1','x2',...,'xp','y'@}}.  This property is read-only.
    ##
    ## @end deftp
    VariableNames = {};

    ## -*- texinfo -*-
    ## @deftp {LinearModel} {property} Variables
    ##
    ## Input data as a table
    ##
    ## A table containing predictor and response values for all observations,
    ## including unused variables.  For table input this is the full input
    ## table.  For matrix input this is a table constructed from the
    ## predictor matrix and response vector.  This property is read-only.
    ##
    ## @end deftp
    Variables = [];

  endproperties

  properties (Access = private, Hidden)

    ## Full design matrix, n by p_design, used for predictions
    DesignMatrix_ = [];

    ## Column indices of active coefficients in the design matrix
    ActiveCols_ = [];

    ## Whether the model includes an intercept term
    HasIntercept_ = true;

    ## Response vector, full n by 1 with NaN for non-subset rows
    ResponseVector_ = [];

  endproperties

  
  methods (Access = public)

    ## Class constructor. 
    function this = LinearModel (varargin)

    endfunction

  endmethods

endclassdef
