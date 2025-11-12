# Project Setup

## Prerequisites

### Windows

Install the following prerequisites:

- [Git for Windows](https://gitforwindows.org/)
  - Ensure to select Git BASH in the installer
  - Git BASH is assumed for all commands below
- [Visual Studio 2026](https://visualstudio.microsoft.com/downloads/)
  - Workloads:
    - .NET desktop development
  - Individual components:
    - .NET 10.0 Runtime
- [ReportGenerator](https://github.com/danielpalme/ReportGenerator)
  - Install via the following command once .NET Core is installed:

    ```shell
    dotnet tool install --global dotnet-reportgenerator-globaltool
    ```

### Linux

Install the following prerequisites:

- [Git](https://git-scm.com/downloads)
- [.NET 10.0 SDK](https://learn.microsoft.com/en-us/dotnet/core/install/linux)
- [Visual Studio Code](https://code.visualstudio.com/docs/setup/linux)
  - Install recommended workspace extensions

### Build and Publish

Run the following script to build and publish the application:

```shell
cd build
./build.sh
```
