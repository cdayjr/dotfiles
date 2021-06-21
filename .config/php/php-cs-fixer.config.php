<?php

return PhpCsFixer\Config::create()
    ->setRules(
        [
            '@PSR1' => true,
            '@PSR2' => true,
            '@Symfony' => true,
            '@PSR12' => true,
            '@PHP71Migration' => true,
            '@PHP70Migration' => true,
            '@PHP56Migration' => true,
            '@DoctrineAnnotation' => true,
            // There must be a comment when fall-through is intentional in a
            // non-empty case body.
            'no_break_comment' => true,
            // Pre- or post-increment and decrement operators should be used if
            // possible.
            'increment_style' => true,
            // There should not be space before or after object
            // `T_OBJECT_OPERATOR` `->`.
            'object_operator_without_whitespace' => true,
            // Sorts PHPDoc types.
            'phpdoc_types_order' => true,
            // PHP multi-line arrays should have a trailing comma.
            'trailing_comma_in_multiline_array' => true,
            // Write conditions in Yoda style (`true`), non-Yoda style (`false`)
            // or ignore those conditions (`null`) based on configuration.
            'yoda_style' => false,
            // Heredoc/nowdoc content must be properly indented. Requires PHP >=
            // 7.3.
            'heredoc_indentation' => false,
            // Use `null` coalescing operator `??` where possible. Requires PHP
            // >= 7.0.
            'ternary_to_null_coalescing' => true,
            // Doctrine annotations must use configured operator for assignment
            // in arrays.
            'doctrine_annotation_array_assignment' => true,
            // Doctrine annotations without arguments must use the configured syntax.
            'doctrine_annotation_braces' => true,
            // Doctrine annotations must be indented with four spaces.
            'doctrine_annotation_indentation' => true,
            // Fixes spaces in Doctrine annotations.
            'doctrine_annotation_spaces' => true,
            // Converts backtick operators to `shell_exec` calls.
            'backtick_to_shell_exec' => true,
            // Using `isset($var) &&` multiple times should be done in one call.
            'combine_consecutive_issets' => true,
            // Calling `unset` on multiple items should be done in one call.
            'combine_consecutive_unsets' => true,
            // Remove extra spaces in a nullable typehint.
            'compact_nullable_typehint' => true,
            // Escape implicit backslashes in strings and heredocs to ease the
            // understanding of which are special chars interpreted by PHP and
            // which not.
            'escape_implicit_backslashes' => [
                'double_quoted' => true,
                'heredoc_syntax' => true,
                'single_quoted' => true,
            ],
            // Converts implicit variables into explicit ones in double-quoted
            // strings or heredoc syntax.
            'explicit_string_variable' => true,
            // Transforms imported FQCN parameters and return types in function
            // arguments to short version.
            'fully_qualified_strict_types' => false,
            // Convert `heredoc` to `nowdoc` where possible.
            'heredoc_to_nowdoc' => true,
            // Ensure there is no code on the same line as the PHP open tag.
            'linebreak_after_opening_tag' => true,
            // DocBlocks must start with two asterisks, multiline comments must
            // start with a single asterisk, after the opening slash. Both must
            // end with a single asterisk before the closing slash.
            'multiline_comment_opening_closing' => true,
            // Forbid multi-line whitespace before the closing semicolon or move
            // the semicolon to the new line for chained calls.
            'multiline_whitespace_before_semicolons' => [
                'strategy' => 'new_line_for_chained_calls',
            ],
            // Replace control structure alternative syntax to use braces.
            'no_alternative_syntax' => false,
            // Properties MUST not be explicitly initialized with `null`.
            'no_null_property_initialization' => true,
            // Replace short-echo `<?=` with long format `<?php echo` syntax.
            'no_short_echo_tag' => false,
            // Replaces superfluous `elseif` with `if`.
            'no_superfluous_elseif' => true,
            // Removes `@param` and `@return` tags that don't provide any useful
            // information.
            'no_superfluous_phpdoc_tags' => true,
            // There should not be useless `else` cases.
            'no_useless_else' => true,
            // There should not be an empty `return` statement at the end of a
            // function.
            'no_useless_return' => true,
            // Annotations in PHPDoc should be ordered so that `@param`
            // annotations come first, then `@throws` annotations, then
            // `@return` annotations.
            'phpdoc_order' => true,
            // Removes extra blank lines after summary and after description in
            // PHPDoc.
            'phpdoc_trim_consecutive_blank_line_separation' => true,
            // Local, dynamic and directly referenced variables should not be
            // assigned and directly returned by a function or method.
            'return_assignment' => true,
            // A return statement wishing to return `void` should not return `null`.
            'simplified_null_return' => true,
            // PHP arrays should be declared using the configured syntax.
            'array_syntax' => [
                'syntax' => 'short',
            ],
            // Each line of multi-line DocComments must have an asterisk [PSR-5]
            // and must be aligned with the first one.
            'align_multiline_comment' => [
                'comment_type' => 'phpdocs_like',
            ],
            // Each element of an array must be indented exactly once.
            'array_indentation' => true,
            // Add curly braces to indirect variables to make them clear to
            // understand. Requires PHP >= 7.0.
            'explicit_indirect_variable' => true,
            // Method chaining MUST be properly indented. Method chaining with
            // different levels of indentation is not supported.
            'method_chaining_indentation' => true,
            // Ordering `use` statements.
            'ordered_imports' => true,
            // All PHPUnit test classes should be marked as internal.
            'php_unit_internal_class' => true,
            // Order `@covers` annotation of PHPUnit tests.
            'php_unit_ordered_covers' => true,
            // All PHPUnit test cases should have `@small`, `@medium` or
            // `@large` annotation to enable run time limits.
            'php_unit_size_class' => true,
            // `@var` and `@type` annotations must have type and name in the
            // correct order.
            'phpdoc_var_annotation_correct_order' => true,
            // Converts explicit variables in double-quoted strings and heredoc
            // syntax from simple to complex format (`${` to `{$`).
            'simple_to_complex_string_variable' => true,
            // String concatenation operator should have one space around it
            'concat_space' => [
                'spacing' => 'one',
            ],
            // Prefer single quotes
            'single_quote' => true,
        ]
    )
    ->setFinder(
        PhpCsFixer\Finder::create()
            ->exclude(
                [
                    '.git',
                    'node_modules',
                    'vendor',
                ]
            )
            ->in(__DIR__)
    );
