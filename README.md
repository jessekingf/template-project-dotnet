# Example .NET Repository

An example repository demonstrating best practices for structuring and managing .NET solutions.

## Goals

The goal of the sample solution is to demonstrate best practices for setting up .NET solutions and projects:

1. Splitting all common project and assembly information out to common property files
2. Making project files small and simple enough to hand-edit
3. Making it easy to add new projects with all common properties automatically set
4. Having static code analysis ([StyleCop](https://github.com/StyleCop/StyleCop) and [FxCop](https://docs.microsoft.com/en-us/visualstudio/code-quality/install-fxcop-analyzers?view=vs-2019)) automatically enabled for all projects
5. Projects that support [Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools)

## Prerequisites

To build the example solution the following must be installed:

- [Visual Studio 2019](https://visualstudio.microsoft.com/downloads/)
  - Workloads:
    - .Net desktop development
    - .NET Core cross-platform development
- [.NET Core 3.1 SDK](https://dotnet.microsoft.com/download/visual-studio-sdks)
  - Note this may already be installed by the Visual Studio install or patches
  - Check your version by running: ```dotnet --version```

## Repository Structure

The repository should contain the following general structure.
The files in this structure will be covered in more detail below.

```
.
|-- src/
|   |-- Example/
|   |   |-- Example.csproj*
|   |   `-- Program.cs*
|   |-- Example.Library/
|   |   |-- Example.Library.csproj*
|   |   `-- Foo.cs*
|   |-- Example.Library.UnitTests/
|   |   |-- Example.Library.UnitTests.csproj*
|   |   `-- FooTests.cs*
|   |-- .editorconfig*
|   |-- CodeAnalysis.ruleset*
|   |-- Common.UnitTests.props*
|   |-- Directory.Build.props*
|   |-- Example.sln*
|   `-- stylecop.json*
|-- .gitattributes*
|-- .gitignore*
|-- README.md*
`-- version.json*
```

## Project Files

All projects in the sample use the new [SDK-style](https://docs.microsoft.com/en-us/nuget/resources/check-project-format) project format.
SDK-Style projects have a number of advantages over the traditional csproj files:

- Very lightweight compared to traditional csproj files
  - Package references are simplified
  - All files in the project directory are automatically included
    - Only files to be excluded are defined in the project file
- Supports all .NET framework types/versions:
    - .NET Core
    - .NET Standard
    - .NET Framework
- Supports [Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools)
  - MSBuild is supported with these project files as well
- Assembly information contained directly in the project files
  - AssemblyInfo.cs is not required (in most cases)
- Easy to generate NuGet packages
  - .Nuspec files are not required (in most cases)
- No custom unit test targets required

### Common Properties

All projects automatically import ```Directory.Build.props```, which sets all common project properties:

- Common meta-data:
  - Company name
  - Author
  - Copyright
- Target framework version
- Enables StyleCop and FxCop
- Sets the build version
- Enables 'Treat warnings' as errors
- Allows unit test projects access to internals

All unit tests projects also automatically import ```Common.UnitTests.props```, which sets all common unit test project properties:

- Includes the appropriate MSTest packages
- Includes the [Coverlet](https://github.com/tonerdo/coverlet) package to report on code coverage
- Enables the project to be run with ```donet test``` (more details below)

Having all common properties automatically imported reduces the chance of creating new projects with incorrect settings.

### Creating New Projects

With the new SDK-style project format and importing common properties each csproj file is quite small, only containing information specific to that project.

When creating a new project file only a few things need to be added/set:

- Project references
- Package references
- Output type (if not a class library)
- Etc.

As shown by the following example this is now quite easy to do by hand:

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
  </PropertyGroup>

  <ItemGroup>
    <ProjectReference Include="..\Example.Library\Example.Library.csproj" />
  </ItemGroup>
</Project>
```

[Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-new) can also be used to create the initial project file:

``` bat
dotnet new classlib -n ProjectName
```

Visual Studio can still be used to update project settings, packages and references.

## Code Analysis

All projects have [StyleCop](https://github.com/StyleCop/StyleCop) and [FxCop](https://docs.microsoft.com/en-us/visualstudio/code-quality/install-fxcop-analyzers?view=vs-2019) enabled.
This ensures static code analysis is run on every build and all code follows the same style guidelines.
Also note the ```.editorconfig``` in the root of the repository. This enforces the code to be formatted the same regardless of visual studio preferences.

The project has been setup with the default rule-sets. Rules can be tweaked in the ```CodeAnalysis.ruleset``` file under the ```src``` directory.

## Building

To build the solution with [Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build):

``` bat
cd src
dotnet build Example.sln
```

Note that ```dotnet build``` will automatically restore packages.

## Running Tests

To run all tests in the solution with [Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-test):

``` bat
cd src
dotnet test Example.sln
```

A code coverage report can be generated with the following options:

``` bat
dotnet test --collect:"XPlat Code Coverage" --results-directory:"CodeCoverage"
```

This generates a [Cobertura](https://github.com/cobertura/cobertura) report (XML) for each project.
From this external tools, such as [ReportGenerator](https://github.com/danielpalme/ReportGenerator), can be used to generate an HTML report.

## Creating and Publishing Packages

NuGet packages can be generated and published with DotNet CLI directly from the project files.
Custom targets using ```nuget.exe``` and ```.nuspec``` files are not required.

See the following links for more details:

- [Quickstart: Create and publish a package (dotnet CLI)](https://docs.microsoft.com/en-us/nuget/quickstart/create-and-publish-a-package-using-the-dotnet-cli)
- [dotnet pack](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-pack)
- [dotnet nuget push](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-nuget-push)
