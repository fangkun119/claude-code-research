# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository is a research project for experimenting with and investigating Claude Code capabilities. The focus is on developing Claude Code Slash Commands, MCP (Model Context Protocol) servers, and Sub Agents for various purposes, with special emphasis on Chinese language document processing using pyramid principles and persuasive structure analysis.

## Repository Structure

- **Root Directory**: Contains the main README.md with project documentation in Chinese
- **.claude/**: Custom Claude Code components (commands, agents, settings)
- **tasks/note/**: Experimental data and test cases for document processing research
  - `test/`: Test cases with various document types (persuasive, narrative, technical, expository)
  - `reference/`: Writing guides, pyramid principle documentation, persuasive techniques
  - `example/`: Example outputs and processed documents
  - `history/`: Version history showing evolution of commands and agents
  - `draft/`: Intermediate files during document processing

## Key Research Areas

The project experiments with:
1. Custom slash commands calling other custom slash commands
2. Sub agents calling slash commands
3. Using filenames as parameters for slash commands and sub agents
4. Data passing between slash commands and sub agents via files
5. Document processing using pyramid principles (conclusion-first, 70%+ bulleted lists)
6. Persuasive structure analysis and logical consistency checking

## Architecture and Components

### Custom Slash Commands (`.claude/commands/`)

**Core Document Processing:**
- **doc-pyramid-rewrite** (172 lines): Core document rewriting using pyramid principles
  - Applies conclusion-first structure with 70%+ bulleted lists
  - Preserves 8 types of argumentative structures
  - Handles different content types with specialized processing
- **doc-refine-titles** (109 lines): Intelligent title generation and hierarchy optimization
  - Analyzes semantic structure to generate hierarchical titles
  - Maintains zero-modification principle for original content
- **doc-highlight-persuasive-structure** (188 lines): Identifies and highlights persuasive elements
  - Recognizes various persuasive techniques and rhetorical structures
- **doc-fluent** (130 lines): Converts content to fluent, conversational paragraphs
- **doc-warn-logic-flaw** (230 lines): Detects logical inconsistencies and flaws

**Text Processing Variants:**
- **text-\*** commands: Text-specific variants with same functionality as doc-* commands

### Custom Agents (`.claude/agents/`)

**doc-rewriter Agent:**
4-Step Document Refinement Pipeline:
1. Title refinement (`/doc-refine-titles`) → creates `{filename}_titled.md`
2. Structure analysis (`/doc-highlight-persuasive-structure`) → creates `{filename}_logic_highlighted.md`
3. Content rewriting using pyramid principles → creates `{filename}_rewritten.md`
4. File organization → moves intermediate files to `draft/` subdirectory

**doc-polisher Agent:**
Final enhancement processing with user requirement analysis:
- Routes to `/doc-fluent` for readability improvements
- Routes to `/doc-warn-logic-flaw` for logical analysis
- Creates final `{filename}_polished.md` output

### Document Processing Pipeline

The research focuses on a structured workflow:
1. **Title Processing**: Optimizes document titles and section headers using semantic analysis
2. **Structure Analysis**: Identifies persuasive techniques and logical flow patterns
3. **Content Rewriting**: Applies pyramid principle (conclusion-first, 70%+ bulleted lists)
4. **Fluency Enhancement**: Improves readability and conversational flow

### File Organization Patterns

**Intermediate Files:**
- `{filename}_titled.md`: After title refinement
- `{filename}_logic_highlighted.md`: After persuasive structure analysis
- `{filename}_rewritten.md`: After pyramid principle rewriting
- `{filename}_polished.md`: Final polished version

**Directory Structure:**
- Test cases in `tasks/note/test/` with before/after comparisons
- Reference materials in `tasks/note/reference/` for writing techniques
- Draft files automatically organized in `draft/` subdirectories
- Extensive history tracking in `tasks/note/history/`

## Development Commands

This is a research repository without traditional build/test infrastructure. All functionality is provided through Claude Code platform configuration.

### Common Operations

**Single Command Processing:**
- Test document processing: `/doc-pyramid-rewrite path/to/document.md`
- Refine titles: `/doc-refine-titles path/to/document.md`
- Analyze persuasive structure: `/doc-highlight-persuasive-structure path/to/document.md`
- Improve fluency: `/doc-fluent path/to/document.md`
- Check logic: `/doc-warn-logic-flaw path/to/document.md`

**Multi-step Pipeline Processing:**
- Run complete refinement pipeline: Use Task tool with doc-rewriter agent
- Apply final polishing: Use Task tool with doc-polisher agent

**File Management:**
- Check permissions: Review `.claude/settings.local.json` for allowed commands
- View test cases: Examine `tasks/note/test/` directory for examples
- Reference guides: Consult `tasks/note/reference/` for writing principles

### Security Configuration

The repository uses granular permission control in `.claude/settings.local.json`:
- Specific bash commands are whitelisted (python3, chmod, cp, find, etc.)
- All custom slash commands require explicit permission
- File operations are restricted to safe patterns
- No external dependencies or runtime requirements

## Language Context

The repository documentation and experimental data are primarily in Chinese, focusing on Claude Code plugin functionality and technical note generation capabilities. The slash commands support both English and Chinese content processing, with special optimization for Chinese language structure and flow patterns.