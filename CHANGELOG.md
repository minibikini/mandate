# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- **CLI Command Router (`Mandate`)**: Declarative router DSL with `commands` block, subcommand registration, default command fallback, and runtime dispatching via `Mandate.dispatch/2`.
- **Subcommand DSL (`Mandate.Command`)**: Standalone command modules with declarative arguments, switches, doc attributes, and `run` execution blocks.
- **Task DSL (`Mandate.Task`)**: Dedicated module for creating Mix tasks (`use Mandate.Task, as: :mix`) and Igniter tasks (`use Mandate.Task, as: :igniter`).
- **Quality Tooling**: Integrated Credo, ExSlop, VibeKit, Reach, and ExDNA with a preconfigured `mix ci` suite.
- Comprehensive test coverage for command routing, fallback resolution, and option parsing.

### Changed

- Updated dependencies: `spark ~> 2.7`, `igniter ~> 0.8`, `ex_doc ~> 0.40`, `reach ~> 2.8`.
- Deprecated legacy `use Mandate, as: :mix_task` / `use Mandate, as: :igniter_task` in favor of `use Mandate.Task`.
- Make positional arguments optional by default.

## [0.3.0] - 2025-03-03

### Added

- Validate options passed to CLI
- Support `@moduledoc` attribute via `longdoc/1`
- Support `@shortdoc` attribute via `shortdoc/1`

## [0.2.1] - 2025-03-02

### Fixed

- Fix version in `mix.exs`

## [0.2.0] - 2025-03-02

### Added

- Validate `run` presence for Mix tasks

## [0.1.0] - 2025-03-01

### Added

- Initial release
