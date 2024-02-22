<?php
/*
 * This document has been generated with
 * https://mlocati.github.io/php-cs-fixer-configurator/#version:2.15.1|configurator
 * you can change this configuration by importing this file.
 */
return PhpCsFixer\Config::create()
    ->setRules(
        [
            '@DoctrineAnnotation' => true,
            '@PHP83Migration' => true,
            '@PhpCsFixer' => true,
            // Each line of multi-line DocComments must have an asterisk [PSR-5]
            // and must be aligned with the first one.
            'align_multiline_comment' => [
                'comment_type' => 'phpdocs_like',
            ],
            // Use `use` statements for importing types
            'fully_qualified_strict_types' => [
              'import_symbols' => true,
            ],
            // Use `use` statements for global namespace types
            'global_namespace_import' => [
              'import_classes' => true,
              'import_constants' => true,
              'import_functions' => true,
            ],
            // Replace control structure alternative syntax to use braces.
            'no_alternative_syntax' => false,
            // All PHPUnit test cases should have `@small`, `@medium` or
            // `@large` annotation to enable run time limits.
            'php_unit_size_class' => true,
            // simplify if returns
            'simplified_if_return' => true,
            // yoda style
            'yoda_style' => [
              'equal' => false,
              'identical' => false,
              'less_and_greater' => false,
            ],
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
    )
;
