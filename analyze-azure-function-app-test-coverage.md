# Analyze Azure Function App Test Coverage

Jan 2018

> Out the box azure function projects do not appear in visual studio test coverage, code snippet add <debugtype>full</debugtype> so project is included in code coverage.

https://github.com/Microsoft/vstest-docs/blob/master/docs/analyze.md 

```
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>netcoreapp1.1</TargetFramework>
    
    <!-- Required in both test/product projects. This is a temporary workaround for https://github.com/Microsoft/vstest/issues/800 -->
    <DebugType>Full</DebugType>
  </PropertyGroup>
...
```