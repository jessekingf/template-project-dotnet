# .NET Template Project

An example repository demonstrating best practices for structuring and managing .NET projects.
This can be used as a template when starting a new project/repository.

Goals:

1. Project files are small and simple enough to hand-edit
2. Code analysis ([.NET Analyzers](https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview) and [StyleCop](https://github.com/StyleCop/StyleCop)) automatically enabled for all projects
3. All common project properties managed in one location
4. New projects automatically inherit all common project properties
5. Projects support [Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools)

## Prerequisites

To build the example solution the following must be installed:

- [Git for Windows](https://gitforwindows.org/)
  - Ensure to select Git BASH in the installer
  - Git BASH is assumed for all commands below
- [Visual Studio 2019](https://visualstudio.microsoft.com/downloads/)
  - Workloads:
    - .NET desktop development
    - .NET Core cross-platform development
  - Individual components:
    - .NET 6.0 Runtime
    - Github Extension for Visual Studio
  - Recommended extensions:
    - [GhostDoc](https://marketplace.visualstudio.com/items?itemName=sergeb.GhostDoc)
    - [Markdown Editor](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.MarkdownEditor2)
    - [Spell Checker](https://marketplace.visualstudio.com/items?itemName=EWoodruff.VisualStudioSpellCheckerVS2022andLater)
- [ReportGenerator](https://github.com/danielpalme/ReportGenerator)
  - Install via the following command once .NET Core is installed:
    ```shell
    dotnet tool install --global dotnet-reportgenerator-globaltool
    ```

## Repository Structure

The repository should contain the following general structure.

```
.
|-- docs/
|-- build/
|   |-- build.sh
|-- dist/
|-- src/
|   |-- Example/
|   |   |-- Example.csproj
|   |   |-- Program.cs
|   |-- Example.Library/
|   |   |-- Example.Library.csproj
|   |   |-- Foo.cs
|   |-- Example.Library.UnitTests/
|   |   |-- Example.Library.UnitTests.csproj
|   |   |-- FooTests.cs
|   |-- .editorconfig
|   |-- .globalconfig
|   |-- Common.UnitTests.props
|   |-- Directory.Build.props
|   |-- Example.sln
|   |-- stylecop.json
|-- test/
|-- .gitattributes
|-- .gitignore
|-- LICENSE.txt
|-- README.md
|-- version.json
```

### Root Directory

- docs/
  - Contains any project documentation
- build/
  - Contains build and publishing scripts
- dist/
  - Contains the build output
  - This directory is ignored by Git
- src/
  - Contains the main source code solution and projects
  - Includes unit test projects
- test/
  - Contains integration/acceptance test solutions and projects
  - This does not contain unit tests
  - This example repository does not demonstrate integration tests
- [.gitattributes](https://git-scm.com/docs/gitattributes)
  - Specifies Git attributes per path
- [.gitignore](https://git-scm.com/docs/gitignore)
  - Specifies intentionally untracked files to ignore in Git (build output, etc.)
- LICENSE.txt
  - Contains the project license information
- README.md
  - You are reading it right now
  - Contains information on the project/repository
  - Written in [Markdown](https://guides.github.com/features/mastering-markdown/)
- version.json
  - Application version configuration (more details below)

More details on the structure and files below.

## Project Files

All projects in the sample use the new [SDK-style](https://docs.microsoft.com/en-us/nuget/resources/check-project-format) project format.
SDK-Style projects have several advantages over the traditional csproj files:

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

All projects automatically import `Directory.Build.props`, which sets all common project properties:

- Common meta-data:
  - Company name
  - Author
  - Copyright
- Target framework version
- Enables [.NET Analyzers](https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview) and [StyleCop](https://github.com/StyleCop/StyleCop)
- Sets the build version (more details below)
- Enables 'Treat warnings' as errors
- Allows unit test projects access to internals

All unit tests projects also automatically import `Common.UnitTests.props`, which sets all common unit test project properties:

- Includes the appropriate MSTest packages
- Includes the [Coverlet](https://github.com/tonerdo/coverlet) package to report on code coverage
- Enables the project to be run with `donet test` (more details below)

Having all common properties automatically imported reduces the chance of creating new projects with incorrect settings.

### Creating New Projects

With all common properties defined in `Directory.Build.props` and automatically imported,
new project files only containing information specific to that project.

When creating a new project file only a few things need to be added/set:

- Project and package references
- Output type (if not a class library)
- Package meta-data (more on this below)
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

```shell
dotnet new classlib -n ProjectName
```

Visual Studio can still be used to update project settings, packages and references.

## Versioning

[Git Versioning](https://github.com/dotnet/Nerdbank.GitVersioning) is used to version the assemblies on build.
By default, the major and minor versions are configured in `version.json`, and the patch version is automatically bumped on each commit.
This setup makes it easier to follow [Semantic Versioning](https://semver.org/) and to have a unique version for every build.

## Code Style and Analysis

### Code Analysis

All projects have both [.NET Analyzers](https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview) and [StyleCop](https://github.com/StyleCop/StyleCop) enabled.
This ensures static code analysis gets run on every build and all code follows the same style guidelines. The rules can be tweaked in the `.globalconfig` file under the `src` directory.

### Code Formatting

The `.editorconfig` file enforces consistent formatting, regardless of the Visual Studio settings.
This allows files to be auto-formatted in Visual Studio and have them comply with the default StyleCop rules.

## Build and Publish

Below covers the commands to build, test, and publish with [Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools).
These commands can be used from your CI/CD platform.

All commands are assumed to be run from the root of the repository.

### Building

To build the solution with [Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build):

```shell
dotnet build src/Example.sln
```

Note that `dotnet build` will automatically [restore packages](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-restore).

### Unit Tests

To run all unit tests in the solution with [Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-test):

```shell
dotnet test src/Example.sln
```

### Test Coverage

A code coverage report can be generated with [Coverlet](https://github.com/tonerdo/coverlet) with the following options:

```shell
rm -rf dist/Coverage
dotnet test src/Example.sln --collect "XPlat Code Coverage" --results-directory "dist/Coverage" --settings "Coverlet.runsettings"
```

This generates a [Cobertura](https://github.com/cobertura/cobertura) report (XML) for each project.
These reports can be integrated with your CI/CD platform or used with external tools.

To generate an HTML report with [ReportGenerator](https://github.com/danielpalme/ReportGenerator):

```shell
reportgenerator -reports:"dist/Coverage/*/*.xml" -targetdir:"dist/Coverage" -reporttypes:HtmlSummary -title:"Unit Test Coverage"
```

### NuGet Packages

NuGet packages can be generated and published with DotNet CLI directly from the project files.
Custom targets using `nuget.exe` and `.nuspec` files are not required for most packages.

To allow a project to be packaged set `IsPackable` to true in the project settings.
If all projects in the solution are to be packaged this can be set in `Directory.Build.props`.

All other meta-data for the package will come from the common properties as well, except for the package description, which is generally project-specific.

Project settings:

```xml
<PropertyGroup>
  <IsPackable>true</IsPackable>
  <Description>Example package description</Description>
</PropertyGroup>
```

To build the packages for the solution with [Dotnet CLI](https://docs.microsoft.com/en-us/nuget/quickstart/create-and-publish-a-package-using-the-dotnet-cli):

```shell
dotnet pack src/Example.sln -o "../dist/Packages"
```

[dotnet nuget push](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-nuget-push) can then be used to publish the packages to the desired server.

See the following links for additional details:

- [Quickstart: Create and publish a package (dotnet CLI)](https://docs.microsoft.com/en-us/nuget/quickstart/create-and-publish-a-package-using-the-dotnet-cli)
- [dotnet pack](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-pack)
- [dotnet nuget push](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-nuget-push)

### Publish Build

To publish an official build with [Dotnet CLI](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish):

```shell
dotnet publish src/Example/Example.csproj -o "../dist/Publish"
```

The publish command also has options for including .NET runtime dependencies and publishing as a [single executable](https://docs.microsoft.com/en-us/dotnet/core/deploying/single-file).

### Sample Build Script

A sample build script is available in the `build` directory that encapsulates all of the above commands:

1. Builds
2. Runs unit tests
3. Generates a test coverage report
3. Creates NuGet packages
4. Publishes the build

The script is a Bash script for better cross-platform compatibility.
These commands/script(s) can be integrated into your CI/CD platform of choice.

To run the script open Git BASH prompt and run the following commands:

```shell
cd build
./build.sh
```

After running the script the published build, packages, and reports can be found in the `dist` folder.

## After Cloning the Template

After cloning the template, update the following for your project:

1. Update the author, copyright, and product information in `Directory.Build.props`
2. Rename the solution and project files
3. Update the build script for the project renames
4. ???
5. Profit!
