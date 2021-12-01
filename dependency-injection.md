# Dependency Injection

May 2018

> Dependency injection also called inversion of control is an architectural approach that decouples code making it easy to maintain and test.

Dependency Injection also called Inversion of Control is an architectural approach that decouples code making it easy to maintain and test. It simply gives the responsibility to the caller to new up any dependencies making code testable and encourages SOILD principles. 

Typically dependencies are Interfaces, Interfaces are fundamental to Test Driven Development mocking, coding against an interfaces decouples code - abstracting away any knowledge of implementation. An Injected resource could be a Sql provider, Oracle provider, No Sql provider or TDD Mock etc.

A useful and easy to understand use case is data persistence. A booking stored in a database. The data stores are Sql provider, Oracle provider, No Sql Provider like Mongo Db, Document Db or Azure Storage.

## The Problem Dependency Injection Addresses

The problem Booking class instantiates all dependancies creating all data providers and processing all associated config making it impossible to unit test.

The rework required to implement a new data persistence technology is major. Anything newd up is a coupling - the code becomes one unit.

User, Resource, Slot classes etc would all need modified to support new data persistence. 

```
public class Service
{
    private IDependency dependency;

    public Service()
    {
        this.dependency = new Dependency();
    }
}
``

## The Solution

A maintainable Booking class all dependancies are injected, all data providers implement required interfaces making the booking class testable, dependancies are mockable.

Dependancies could be a Sql implementation, Azure Storage or Document Db etc. The maintainable Booking class only has knowledge of the interface making dependancies swappable with ease.

The same dependency instance can be shared across multiple classes for example current User improving performance.

Newing up classes are the responsibly of the root application normally managed by a container. 

```
public class Service
{
    private readonly IDependency dependency;

    public Service(IDependency dependency)
    {
        this.dependency = dependency;
    }
}
```

## Apply to Projects
Apply the same strategy to projects. Business logic classes & interfaces are contained in a domain/model project with runtime dependencies.

Various data persistence projects are created, one for each technology, each implementing applicable interfaces.

One project for Entity Framework imports and implements domain/model data interfaces. 
One project for Azure Storage imports and implements domain/model data interfaces. 
One project for Document Db imports and implements domain/model data interfaces. 
Etc
The root application (Booking Website) takes many flavours for example using Entity Framework or using Azure Storage. Later a business need emerges to use Document Db for storage, the root application (Booking Website) and Business logic would not require any rework, only an implementation of a Document Db new data project.