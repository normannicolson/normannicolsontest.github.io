# Mermaid

> Mermaid syntax and tool allows creation of key Uml diagrams using text  

Mermaid is diagramming tool/syntax for text definitions.

It is a JavaScript based diagramming and charting tool that renders Markdown-inspired text definitions to create and modify diagrams dynamically.

## Sequence Diagram

```mermaid
sequenceDiagram
    participant A as Controller
    participant B as Query Handler
    participant C as Data Store

    A ->> B: Get appointment info query

    B ->> C: Query
    C -->> B: Data

    loop Map
        B->> B: Map values to model
    end
    
    B -->> A: Model

    Note left of C: Note Text <br/>new line.
    Note right of C: Note Text <br/>new line.
```

## Class Diagram

```mermaid
classDiagram
    class Building{
        guid id
        List~Room~ Rooms 
        AddRoom()
    }

    class Room{        
        guid id
    }

    Building *-- Room
```

https://mermaid-js.github.io/
