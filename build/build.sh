#!/bin/bash
set -e

# Build parameters
appName=Example
src=../src
sln=$src/Example.sln
mainProj=$src/Example/Example.csproj

dist=../dist
publishDir=$dist/Publish
packagesDir=$dist/Packages
coverageDir=$dist/Coverage

config=Release

# Clean
echo Cleaning...
rm -rf $dist
dotnet clean "$sln" -c $config

# Build
echo Building solution...
dotnet restore "$sln"
dotnet build "$sln" -c $config --no-restore --no-incremental 

# Run unit tests
echo Running tests...
dotnet test "$sln" -c $config --no-restore --no-build --collect "XPlat Code Coverage" --results-directory "$coverageDir" --settings "$src/coverlet.runsettings"
if [ -d "$coverageDir" ]; then
  reportgenerator -reports:"$coverageDir/*/*.xml" -targetdir:"$coverageDir" -reporttypes:HtmlSummary -title:"Unit Test Coverage"
fi

# Create packages
echo Creating packages...
dotnet pack "$sln" -c $config -o "$packagesDir" --no-restore --no-build

# Create distribution
echo Creating distribution...
dotnet publish $mainProj -c $config -r linux-x64 -o "$publishDir/$appName-Linux-x64"
dotnet publish $mainProj -c $config -r win-x64 -o "$publishDir/$appName-Win-x64"
rm -f "$publishDir"/**/*.pdb
rm -f "$publishDir"/**/*.xml

# Build succeeded
echo Build successful
exit 0
