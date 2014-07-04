-module(rules_SUITE).

-export([
         all/0,
         init_per_suite/1,
         end_per_suite/1
        ]).

-export([
         verify_line_length_rule/1,
         verify_no_tabs_rule/1,
         verify_macro_names_rule/1,
         verify_macro_module_names/1
        ]).

-define(EXCLUDED_FUNS,
        [
         module_info,
         all,
         test,
         init_per_suite,
         end_per_suite
        ]).

-type config() :: [{atom(), term()}].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Common test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-spec all() -> [atom()].
all() ->
    Exports = ?MODULE:module_info(exports),
    [F || {F, _} <- Exports, not lists:member(F, ?EXCLUDED_FUNS)].

-spec init_per_suite(config()) -> config().
init_per_suite(Config) ->
    application:start(elvis),
    Config.

-spec end_per_suite(config()) -> config().
end_per_suite(Config) ->
    application:stop(elvis),
    Config.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Test Cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%
%%% Rules

-spec verify_line_length_rule(config()) -> any().
verify_line_length_rule(_Config) ->
    ElvisConfig = elvis_config:default(),
    #{src_dirs := SrcDirs} = ElvisConfig,

    File = "fail_line_length.erl",
    {ok, Path} = elvis_test_utils:find_file(SrcDirs, File),

    [_, _] = elvis_style:line_length(ElvisConfig, Path, [80]).

-spec verify_no_tabs_rule(config()) -> any().
verify_no_tabs_rule(_Config) ->
    ElvisConfig = elvis_config:default(),
    #{src_dirs := SrcDirs} = ElvisConfig,

    File = "fail_no_tabs.erl",
    {ok, Path} = elvis_test_utils:find_file(SrcDirs, File),

    [_, _] = elvis_style:no_tabs(ElvisConfig, Path, []).

-spec verify_macro_names_rule(config()) -> any().
verify_macro_names_rule(_Config) ->
    ElvisConfig = elvis_config:default(),
    #{src_dirs := SrcDirs} = ElvisConfig,

    File = "fail_macro_names.erl",
    {ok, Path} = elvis_test_utils:find_file(SrcDirs, File),

    [_, _] = elvis_style:macro_names(ElvisConfig, Path, []).

-spec verify_macro_module_names(config()) -> any().
verify_macro_module_names(_Config) ->
    ElvisConfig = elvis_config:default(),
    #{src_dirs := SrcDirs} = ElvisConfig,
    
    File = "fail_macro_module_names.erl",
    {ok, Path} = elvis_test_utils:find_file(SrcDirs, File),

    [_, _, _, _] = elvis_style:macro_module_names(ElvisConfig, Path, []).