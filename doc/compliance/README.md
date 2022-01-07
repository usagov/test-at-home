# compliance artifacts

## What is this?

In order to maintain and revise compliance materials with minimal fuss, we store all artifacts as text source (eg Markdown, PlantUML, OSCAL), then generate rendered materials for consumption by downstream entities in the assessment and authorization process.

This directory initially just contains system architecture diagrams corresponding to sections 1-12 of a typical System Security Plan (SSP) document.

The source for other things (OSCAL for control descriptions, evidence generation scripts, etc) will appear here over time.

## Development

These plugins may be helpful for editing diagrams.

- vscode: [PlantUML extension](https://marketplace.visualstudio.com/items?itemName=jebbs.plantuml)
  - Use "PlantUML: Export Current File Diagrams" to render the diagram in the current file (eg while iterating)
  - Use "PlantUML: Export Workspace Diagrams" to render all diagrams (eg before pushing a branch)
- vim: [weirongxu/plantuml-previewer.vim](https://github.com/weirongxu/plantuml-previewer.vim)
- vim: [aklt/plantuml-syntax](https://github.com/aklt/plantuml-syntax)
