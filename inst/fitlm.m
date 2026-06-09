## Copyright (C) 2022 Andrew Penn <A.C.Penn@sussex.ac.uk>
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

## -*- texinfo -*-
## @deftypefn  {statistics} {@var{mdl} =} fitlm (@var{X}, @var{y})
## @deftypefnx {statistics} {@var{mdl} =} fitlm (@var{tbl})
## @deftypefnx {statistics} {@var{mdl} =} fitlm (@var{tbl}, @var{ResponseVarName})
## @deftypefnx {statistics} {@var{mdl} =} fitlm (@var{tbl}, @var{y})
## @deftypefnx {statistics} {@var{mdl} =} fitlm (@dots{}, @var{modelspec})
## @deftypefnx {statistics} {@var{mdl} =} fitlm (@dots{}, @var{Name}, @var{Value}, @dots{})
##
## Fit a linear regression model.
##
## @end deftypefn

function mdl = fitlm (varargin)

  if (nargin < 1)
    error ("fitlm: Not enough input arguments.");
  endif

  ## List of Name-Value keys used to check if the response variable y is missing.
  nv_keys = {"varnames", "intercept", "responsevar", "predictorvars", ...
             "categoricalvars", "exclude", "weights", "robustopts"};
  is_nv = @(s) (ischar (s) || isstring (s)) && ...
               any (strcmpi (char (s), nv_keys));

  arg1 = varargin{1};
  rest = varargin(2:end);

  if (istable (arg1))

    response  = [];
    modelspec = [];
    nv_args   = {};

    if (! isempty (rest))

      ## Even length starting with Name-Value key means all are Name-Value pairs
      if (mod (numel (rest), 2) == 0 && is_nv (rest{1}))
        nv_args = rest;

      else
        arg2       = rest{1};
        after_arg2 = rest(2:end);
        n_rows     = height (arg1);
        n_cols     = width  (arg1);
        col_names  = arg1.Properties.VariableNames;

        if (ischar (arg2) || isstring (arg2))
          s = char (arg2);

          if (any (s == '~'))
            ## Wilkinson formula string
            modelspec = s;
            if (mod (numel (after_arg2), 2) != 0)
              error ("fitlm: Name-Value arguments must be in pairs.");
            endif
            nv_args = after_arg2;

          elseif (any (strcmp (s, col_names)))
            ## Response variable name; ODD/EVEN for remainder
            response = s;
            [modelspec, nv_args] = lm_split_args (after_arg2);

          else
            ## Modelspec keyword or invalid string; LinearModel will validate
            modelspec = s;
            if (mod (numel (after_arg2), 2) != 0)
              error ("fitlm: Name-Value arguments must be in pairs.");
            endif
            nv_args = after_arg2;
          endif

        elseif (isnumeric (arg2) || islogical (arg2))
          [nr2, nc2] = size (arg2);

          if (isempty (arg2))
            error (["fitlm: The terms matrix must have one column for each " ...
                    "variable in the dataset or table."]);

          elseif (nc2 == n_cols)
            ## Column count matches table, so it is a terms matrix
            if (! any (all (double (arg2) == 0, 1)))
              error (["fitlm: Cannot determine the response variable from " ...
                      "the terms matrix."]);
            endif
            modelspec = double (arg2);
            if (mod (numel (after_arg2), 2) != 0)
              error ("fitlm: Name-Value arguments must be in pairs.");
            endif
            nv_args = after_arg2;

          elseif (nc2 == 1 && nr2 == n_rows)
            ## Single column matching table height is an external y vector
            response = double (arg2(:));
            [modelspec, nv_args] = lm_split_args (after_arg2);

          else
            error ("fitlm: Predictor and response variables must have the same length.");
          endif

        else
          error ("fitlm: invalid second argument for table input.");
        endif
      endif
    endif

    mdl = LinearModel ("table", arg1, response, modelspec, nv_args{:});

  elseif ((isnumeric (arg1) || islogical (arg1)) && ismatrix (arg1))

    n = size (arg1, 1);

    ## Ensure the response variable y is provided.
    if (isempty (rest) || is_nv (rest{1}))
      error ("fitlm: Y argument is required unless X is a dataset or table.");
    endif

    arg2 = rest{1};

    ## Ensure the response variable has the correct length.
    if (max ([size(arg2), 0]) != n)
      error ("fitlm: Predictor and response variables must have the same length.");
    endif

    if (! isvector (arg2))
      error ("fitlm: Response variable must be a numeric vector.");
    endif

    if (! isnumeric (arg2) && ! islogical (arg2))
      error ("fitlm: Response variable must be a numeric vector.");
    endif

    y = double (arg2(:));
    [modelspec, nv_args] = lm_split_args (rest(2:end));

    mdl = LinearModel ("matrix", arg1, y, modelspec, nv_args{:});

  else
    error (["fitlm: Predictor variables must be numeric vectors, numeric " ...
            "matrices, or categorical vectors."]);
  endif

endfunction


## If count is odd, the first element is the modelspec and the rest are Name-Value pairs.
## If count is even, there is no modelspec and all elements are Name-Value pairs.
function [modelspec, nv_args] = lm_split_args (remaining)
  if (isempty (remaining))
    modelspec = [];
    nv_args   = {};
  elseif (mod (numel (remaining), 2) == 1)
    modelspec = remaining{1};
    nv_args   = remaining(2:end);
  else
    modelspec = [];
    nv_args   = remaining;
  endif
endfunction


%!shared X, y, yl, T1, T2, T3
%! X  = [1 2; 3 4; 5 6];
%! y  = [2; 4; 5];
%! yl = logical ([1; 0; 1]);
%! T1 = table ([1;2;3], [4;5;6], 'VariableNames', {'x1','x2'});
%! T2 = table ([1;2;3], [4;5;6], 'VariableNames', {'x1','y'});
%! T3 = table ([1;2;3], [4;5;6], [2;4;5], 'VariableNames', {'x1','x2','y'});

## fitlm (X, y) 
%!test 
%! assert (class (fitlm (X, y)), 'LinearModel');
%!test 
%! assert (class (fitlm (X, yl)), 'LinearModel');

## fitlm (X, y) with model specification
%!test 
%! assert (class (fitlm (X, y, 'linear')), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'constant')), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'interactions')), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'purequadratic')), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'quadratic')), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, [1 0; 0 1])), 'LinearModel');

## fitlm (X, y) with model specification and name-value pairs
%!test 
%! assert (class (fitlm (X, y, 'linear', 'Weights', [1;2;1])), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'linear', 'Intercept', true)), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'quadratic', 'Intercept', false)), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'linear', 'Exclude', [1])), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'linear', 'CategoricalVars', logical ([1 0]))), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'linear', 'Intercept', true, 'Weights', [1;2;1])), 'LinearModel');

## fitlm (X, y) with name-value pairs
%!test 
%! assert (class (fitlm (X, y, 'Intercept', false)), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'Weights', [1;2;1])), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'Exclude', [1])), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'VarNames', {'a','b','y'})), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'CategoricalVars', [1])), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'RobustOpts', 'on')), 'LinearModel');
%!test 
%! assert (class (fitlm (X, y, 'ResponseVar', 'y')), 'LinearModel');

## fitlm (Table) 
%!test 
%! assert (class (fitlm (T2)), 'LinearModel');
%!test 
%! assert (class (fitlm (T3)), 'LinearModel');

## fitlm (Table) with response variable name
%!test 
%! assert (class (fitlm (T2, 'y')), 'LinearModel');
%!test 
%! assert (class (fitlm (T2, 'x1')), 'LinearModel');
%!test 
%! assert (class (fitlm (T3, 'y')), 'LinearModel');

## fitlm (Table) with Wilkinson formula
%!test 
%! assert (class (fitlm (T3, 'y ~ x1')), 'LinearModel');
%!test 
%! assert (class (fitlm (T3, 'y ~ x1 + x2')), 'LinearModel');
%!test 
%! assert (class (fitlm (T3, 'y ~ x1 - 1')), 'LinearModel');

## fitlm (Table) with external response vector
%!test 
%! assert (class (fitlm (T1, [2;4;5])), 'LinearModel');

## fitlm (Table) with name-value pairs
%!test 
%! assert (class (fitlm (T1, 'linear')), 'LinearModel');
%!test 
%! assert (class (fitlm (T1, 'constant')), 'LinearModel');
%!test 
%! assert (class (fitlm (T2, [0 0; 1 0])), 'LinearModel');
%!test 
%! assert (class (fitlm (T1, [2;4;5], 'linear')), 'LinearModel');
%!test 
%! assert (class (fitlm (T1, [2;4;5], 'Intercept', false)), 'LinearModel');
%!test 
%! assert (class (fitlm (T3, 'y ~ x1', 'Intercept', true)), 'LinearModel');
%!test 
%! assert (class (fitlm (T3, 'Exclude', [2])), 'LinearModel');
%!test 
%! assert (class (fitlm (T3, 'Intercept', false)), 'LinearModel');
%!test 
%! assert (class (fitlm (T3, 'Weights', [1;2;1])), 'LinearModel');
%!test 
%! assert (class (fitlm (T2, 'y', 'linear')), 'LinearModel');
%!test 
%! assert (class (fitlm (T2, 'y', 'constant')), 'LinearModel');
%!test 
%! assert (class (fitlm (T2, 'y', 'Intercept', false)), 'LinearModel');
%!test 
%! assert (class (fitlm (T2, 'y', 'Exclude', [1])), 'LinearModel');
%!test 
%! assert (class (fitlm (T2, 'y', 'linear', 'Intercept', false)), 'LinearModel');
%!test 
%! assert (class (fitlm (T1, 'linear', 'Weights', [1;2;1])), 'LinearModel');

%!error <Not enough input arguments> fitlm ()
%!error <Predictor variables must be numeric vectors, numeric matrices, or categorical vectors> fitlm ("hello", y)
%!error <Predictor variables must be numeric vectors, numeric matrices, or categorical vectors> fitlm ({'a';'b'}, [1;2])
%!error <Predictor variables must be numeric vectors, numeric matrices, or categorical vectors> fitlm (struct ('a', 1), [1;2])
%!error <Y argument is required unless X is a dataset or table> fitlm (X)
%!error <Y argument is required unless X is a dataset or table> fitlm (X, 'Weights', [1;1;1])
%!error <Y argument is required unless X is a dataset or table> fitlm (X, 'Intercept', false)
%!error <Y argument is required unless X is a dataset or table> fitlm (X, 'Exclude', [1])
%!error <Y argument is required unless X is a dataset or table> fitlm (X, 'CategoricalVars', [1])
%!error <Y argument is required unless X is a dataset or table> fitlm (X, 'VarNames', {'a','b','y'})
%!error <Predictor and response variables must have the same length> fitlm (X, [])
%!error <Predictor and response variables must have the same length> fitlm (X, [1;2])
%!error <Predictor and response variables must have the same length> fitlm (X, [1 2])
%!error <Predictor and response variables must have the same length> fitlm (X, "hi")
%!error <Predictor and response variables must have the same length> fitlm (X, "hello")
%!error <Predictor and response variables must have the same length> fitlm (X, ones (2, 1))
%!error <Response variable must be a numeric vector> fitlm (X, ones (3, 2))
%!error <Response variable must be a numeric vector> fitlm (X, ones (3, 3))
%!error <Response variable must be a numeric vector> fitlm (X, {'1';'2';'3'})
%!error <The terms matrix must have one column for each variable in the dataset or table> fitlm (T1, [])
%!error <Cannot determine the response variable from the terms matrix> fitlm (T1, ones (1, 2))
%!error <Cannot determine the response variable from the terms matrix> fitlm (T2, ones (2, 2))
%!error <Predictor and response variables must have the same length> fitlm (T1, ones (4, 1))
%!error <Predictor and response variables must have the same length> fitlm (T1, ones (2, 3))
%!error <Predictor and response variables must have the same length> fitlm (T1, ones (1, 1))
%!error <Name-Value arguments must be in pairs> fitlm (T2, 'y ~ x1', 'linear')
%!error <Name-Value arguments must be in pairs> fitlm (T3, 'y ~ x1 + x2', 'Intercept')
%!error <Name-Value arguments must be in pairs> fitlm (T2, 'linear', 'Intercept')
%!error <Name-Value arguments must be in pairs> fitlm (T1, 'quadratic', 'Weights')
%!error <Name-Value arguments must be in pairs> fitlm (T2, 'constant', 'Exclude')