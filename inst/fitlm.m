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

  if (isa (arg1, 'categorical'))
    if (! isvector (arg1))
      error (["fitlm: Predictor variables must be numeric vectors, numeric " ...
              "matrices, or categorical vectors."]);
    endif
    if (isempty (rest) || is_nv (rest{1}))
      error ("fitlm: Y argument is required unless X is a dataset or table.");
    endif
    y_arg = rest{1};
    if (numel (y_arg) != size (arg1, 1))
      error ("fitlm: Predictor and response variables must have the same length.");
    endif
    if (! isvector (y_arg) || (! isnumeric (y_arg) && ! islogical (y_arg)))
      error ("fitlm: Response variable must be a numeric vector.");
    endif

    pred_name = 'x1';
    resp_name = 'y';
    tail      = rest(2:end);
    keep      = true (1, numel (tail));
    for k = 1:2:numel (tail)-1
      if (ischar (tail{k}) && strcmpi (tail{k}, 'VarNames') && iscell (tail{k+1}))
        vn = tail{k+1};
        if (numel (vn) >= 1); pred_name = vn{1}; endif
        if (numel (vn) >= 2); resp_name = vn{2}; endif
        keep(k:k+1) = false;
      endif
    endfor
    tail = tail(keep);

    tbl = table (arg1(:), double (y_arg(:)), 'VariableNames', {pred_name, resp_name});
    mdl = fitlm (tbl, tail{:});
    return;
  endif

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

    mdl = LinearModel (arg1, response, modelspec, nv_args{:});

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

    mdl = LinearModel (arg1, y, modelspec, nv_args{:});

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

%!demo
%! y =  [ 8.706 10.362 11.552  6.941 10.983 10.092  6.421 14.943 15.931 ...
%!        22.968 18.590 16.567 15.944 21.637 14.492 17.965 18.851 22.891 ...
%!        22.028 16.884 17.252 18.325 25.435 19.141 21.238 22.196 18.038 ...
%!        22.628 31.163 26.053 24.419 32.145 28.966 30.207 29.142 33.212 ...
%!        25.694 ]';
%! X = [1 1 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5]';
%!
%! mdl = fitlm (X, y, 'linear', 'CategoricalVars', 1)

%!demo
%! popcorn = [5.5, 4.5, 3.5; 5.5, 4.5, 4.0; 6.0, 4.0, 3.0; ...
%!            6.5, 5.0, 4.0; 7.0, 5.5, 5.0; 7.0, 5.0, 4.5];
%! brands = {'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'};
%! popper = {'oil', 'oil', 'oil'; 'oil', 'oil', 'oil'; 'oil', 'oil', 'oil'; ...
%!           'air', 'air', 'air'; 'air', 'air', 'air'; 'air', 'air', 'air'};
%!
%! T = table (brands(:), popper(:), 'VariableNames', {'brands', 'popper'});
%! mdl = fitlm (T, popcorn(:), 'interactions')

%!test
%! y =  [ 8.706 10.362 11.552  6.941 10.983 10.092  6.421 14.943 15.931 ...
%!        22.968 18.590 16.567 15.944 21.637 14.492 17.965 18.851 22.891 ...
%!        22.028 16.884 17.252 18.325 25.435 19.141 21.238 22.196 18.038 ...
%!        22.628 31.163 26.053 24.419 32.145 28.966 30.207 29.142 33.212 ...
%!        25.694 ]';
%! X = [1 1 1 1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5]';
%! fitlm (X, y, 'CategoricalVars', 1);
%! fitlm (X, y, 'constant', 'CategoricalVars', 1);
%! fitlm (X, y, 'linear', 'CategoricalVars', 1);
%! mdl = fitlm (X, y, 'linear', 'CategoricalVars', 1);
%! assert (mdl.Coefficients.Estimate(1), 10, 1e-04);
%! assert (mdl.Coefficients.Estimate(2), 7.99999999999999, 1e-09);
%! assert (mdl.Coefficients.Estimate(3), 8.99999999999999, 1e-09);
%! assert (mdl.Coefficients.Estimate(4), 11.0001428571429, 1e-09);
%! assert (mdl.Coefficients.Estimate(5), 19.0001111111111, 1e-09);
%! assert (mdl.Coefficients.SE(1), 1.01775379540949, 1e-09);
%! assert (mdl.Coefficients.SE(2), 1.64107868458008, 1e-09);
%! assert (mdl.Coefficients.SE(3), 1.43932122062479, 1e-09);
%! assert (mdl.Coefficients.SE(4), 1.48983900477565, 1e-09);
%! assert (mdl.Coefficients.SE(5), 1.3987687997822, 1e-09);
%! assert (mdl.Coefficients.tStat(1), 9.82555903510687, 1e-09);
%! assert (mdl.Coefficients.tStat(2), 4.87484242844031, 1e-09);
%! assert (mdl.Coefficients.tStat(3), 6.25294748040552, 1e-09);
%! assert (mdl.Coefficients.tStat(4), 7.38344399756088, 1e-09);
%! assert (mdl.Coefficients.tStat(5), 13.5834536158296, 1e-09);
%! assert (mdl.Coefficients.pValue(2), 2.85812420217862e-05, 1e-12);
%! assert (mdl.Coefficients.pValue(3), 5.22936741204002e-07, 1e-06);
%! assert (mdl.Coefficients.pValue(4), 2.12794763209106e-08, 1e-07);
%! assert (mdl.Coefficients.pValue(5), 7.82091664406755e-15, 1e-08);

%!test
%! popcorn = [5.5, 4.5, 3.5; 5.5, 4.5, 4.0; 6.0, 4.0, 3.0; ...
%!            6.5, 5.0, 4.0; 7.0, 5.5, 5.0; 7.0, 5.0, 4.5];
%! brands = bsxfun (@times, ones (6, 1), [1, 2, 3]);
%! popper = bsxfun (@times, [1; 1; 1; 2; 2; 2], ones (1, 3));
%! X = [brands(:), popper(:)];
%! mdl = fitlm (X, popcorn(:), 'interactions', 'CategoricalVars', [1, 2]);
%! assert (mdl.Coefficients.Estimate(1),  5.66666666666667, 1e-09);
%! assert (mdl.Coefficients.Estimate(2), -1.33333333333333, 1e-09);
%! assert (mdl.Coefficients.Estimate(3), -2.16666666666667, 1e-09);
%! assert (mdl.Coefficients.Estimate(4),  1.16666666666667, 1e-09);
%! assert (mdl.Coefficients.Estimate(6), -0.333333333333334, 1e-09);
%! assert (mdl.Coefficients.Estimate(7), -0.166666666666667, 1e-09);
%! assert (mdl.Coefficients.SE(1), 0.215165741455965, 1e-09);
%! assert (mdl.Coefficients.SE(2), 0.304290309725089, 1e-09);
%! assert (mdl.Coefficients.SE(3), 0.304290309725089, 1e-09);
%! assert (mdl.Coefficients.SE(4), 0.304290309725089, 1e-09);
%! assert (mdl.Coefficients.SE(6), 0.43033148291193, 1e-09);
%! assert (mdl.Coefficients.SE(7), 0.43033148291193, 1e-09);
%! assert (mdl.Coefficients.tStat(1),  26.3362867542108,   1e-09);
%! assert (mdl.Coefficients.tStat(2),  -4.38178046004138,  1e-09);
%! assert (mdl.Coefficients.tStat(3),  -7.12039324756724,  1e-09);
%! assert (mdl.Coefficients.tStat(4),   3.83405790253621,  1e-09);
%! assert (mdl.Coefficients.tStat(6),  -0.774596669241495, 1e-09);
%! assert (mdl.Coefficients.tStat(7),  -0.387298334620748, 1e-09);
%! assert (mdl.Coefficients.pValue(1), 5.49841502258254e-12, 1e-09);
%! assert (mdl.Coefficients.pValue(2), 0.000893505495903642, 1e-09);
%! assert (mdl.Coefficients.pValue(3), 1.21291454302428e-05, 1e-09);
%! assert (mdl.Coefficients.pValue(4), 0.00237798044119407,  1e-09);
%! assert (mdl.Coefficients.pValue(6), 0.453570536021938,    1e-09);
%! assert (mdl.Coefficients.pValue(7), 0.705316781644046,    1e-09);
%! brands = {'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'; ...
%!           'Gourmet', 'National', 'Generic'};
%! popper = {'oil', 'oil', 'oil'; 'oil', 'oil', 'oil'; 'oil', 'oil', 'oil'; ...
%!           'air', 'air', 'air'; 'air', 'air', 'air'; 'air', 'air', 'air'};
%! T = table (brands(:), popper(:), 'VariableNames', {'brands', 'popper'});
%! mdl = fitlm (T, popcorn(:), 'interactions');

%!test
%! load carsmall
%! X = [Weight, Horsepower, Acceleration];
%! fitlm (X, MPG, 'constant');
%! mdl = fitlm (X, MPG, 'linear');
%! assert (mdl.Coefficients.Estimate(1),  47.9767628118615,     1e-09);
%! assert (mdl.Coefficients.Estimate(2),  -0.00654155878851796, 1e-09);
%! assert (mdl.Coefficients.Estimate(3),  -0.0429433065881864,  1e-09);
%! assert (mdl.Coefficients.Estimate(4),  -0.0115826516894871,  1e-09);
%! assert (mdl.Coefficients.SE(1), 3.87851641748551,            1e-09);
%! assert (mdl.Coefficients.SE(2), 0.00112741016370336,         1e-09);
%! assert (mdl.Coefficients.SE(3), 0.0243130608813806,          1e-09);
%! assert (mdl.Coefficients.SE(4), 0.193325043113178,           1e-09);
%! assert (mdl.Coefficients.tStat(1),  12.369874881944,         1e-09);
%! assert (mdl.Coefficients.tStat(2),  -5.80228828790225,       1e-09);
%! assert (mdl.Coefficients.tStat(3),  -1.76626492228599,       1e-09);
%! assert (mdl.Coefficients.tStat(4),  -0.0599128364487485,     1e-09);
%! assert (mdl.Coefficients.pValue(1), 4.89570341688996e-21,    1e-09);
%! assert (mdl.Coefficients.pValue(2), 9.87424814144e-08,       1e-09);
%! assert (mdl.Coefficients.pValue(3), 0.0807803098213114,      1e-09);
%! assert (mdl.Coefficients.pValue(4), 0.952359384151778,       1e-09);

%!shared X, y, yl, T1, T2, T3, C
%! X  = [1 2; 3 4; 5 6];
%! y  = [2; 4; 5];
%! yl = logical ([1; 0; 1]);
%! T1 = table ([1;2;3], [4;5;6], 'VariableNames', {'x1','x2'});
%! T2 = table ([1;2;3], [4;5;6], 'VariableNames', {'x1','y'});
%! T3 = table ([1;2;3], [4;5;6], [2;4;5], 'VariableNames', {'x1','x2','y'});
%! C  = categorical ({'a';'b';'a'});

%!test
%! assert (class (fitlm (X, y)), 'LinearModel');
%!test
%! assert (class (fitlm (X, yl)), 'LinearModel');
%!test
%! assert (class (fitlm (X, y, 'linear')), 'LinearModel');
%!test
%! assert (class (fitlm (X, y, [1 0; 0 1])), 'LinearModel');
%!test
%! assert (class (fitlm (X, y, 'Intercept', false)), 'LinearModel');
%!test
%! assert (class (fitlm (X, y, 'linear', 'Weights', [1;2;1])), 'LinearModel');

%!test
%! mdl = fitlm (C, y);
%! assert (class (mdl), 'LinearModel');
%! assert (mdl.VariableNames, {'x1', 'y'});
%!test
%! mdl = fitlm (C, y, 'VarNames', {'grp', 'score'});
%! assert (mdl.VariableNames, {'grp', 'score'});
%!test
%! assert (class (fitlm (C, y, 'Intercept', false)), 'LinearModel');

%!test
%! assert (class (fitlm (T2)), 'LinearModel');
%!test
%! assert (class (fitlm (T3)), 'LinearModel');
%!test
%! assert (class (fitlm (T3, 'Exclude', [2])), 'LinearModel');
%!test
%! assert (class (fitlm (T2, 'y')), 'LinearModel');
%!test
%! assert (class (fitlm (T3, 'x1')), 'LinearModel');
%!test
%! assert (class (fitlm (T3, 'y ~ x1 + x2')), 'LinearModel');
%!test
%! assert (class (fitlm (T1, 'linear')), 'LinearModel');
%!test
%! assert (class (fitlm (T1, [2;4;5])), 'LinearModel');
%!test
%! assert (class (fitlm (T2, [0 0; 1 0])), 'LinearModel');
%!test
%! assert (class (fitlm (T2, 'y', 'linear', 'Intercept', false)), 'LinearModel');

%!error <Not enough input arguments> fitlm ()
%!error <Predictor variables must be numeric vectors, numeric matrices, or categorical vectors> ...
%! fitlm ("hello", y)
%!error <Predictor variables must be numeric vectors, numeric matrices, or categorical vectors> ...
%! fitlm (struct ('a', 1), [1;2])
%!error <Predictor variables must be numeric vectors, numeric matrices, or categorical vectors> ...
%! fitlm (categorical ([1 2; 3 4]), y)
%!error <Y argument is required unless X is a dataset or table> ...
%! fitlm (C)
%!error <Y argument is required unless X is a dataset or table> ... 
%! fitlm (C, 'Intercept', false)
%!error <Predictor and response variables must have the same length> ...
%! fitlm (C, [1;2])
%!error <Response variable must be a numeric vector> fitlm (C, {'a';'b';'a'})
%!error <Y argument is required unless X is a dataset or table> fitlm (X)
%!error <Y argument is required unless X is a dataset or table> ... 
%! fitlm (X, 'Weights', [1;1;1])
%!error <Predictor and response variables must have the same length> ...
%! fitlm (X, [])
%!error <Predictor and response variables must have the same length> ...
%! fitlm (X, [1;2])
%!error <Response variable must be a numeric vector> fitlm (X, ones (3, 2))
%!error <Response variable must be a numeric vector> fitlm (X, {'1';'2';'3'})
%!error <The terms matrix must have one column for each variable in the dataset or table> ...
%! fitlm (T1, [])
%!error <Cannot determine the response variable from the terms matrix> ...
%! fitlm (T1, ones (1, 2))
%!error <Predictor and response variables must have the same length> ...
%! fitlm (T1, ones (4, 1))
%!error <Predictor and response variables must have the same length> ...
%! fitlm (T1, ones (2, 3))
%!error <invalid second argument for table input> fitlm (T1, {1, 2})
%!error <Name-Value arguments must be in pairs> fitlm (T2, 'y ~ x1', 'linear')
%!error <Name-Value arguments must be in pairs> fitlm (T1, 'linear', 'Weights')
%!error <Name-Value arguments must be in pairs> fitlm (T2, [0 0; 1 0], 'Weights')