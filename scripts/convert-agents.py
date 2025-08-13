#!/usr/bin/env python3
"""
Convert YAML agent files to Markdown format required by Claude Code.
Converts from pure YAML to Markdown with YAML frontmatter.
"""

import yaml
import sys
import os
from pathlib import Path

def convert_yaml_to_md(yaml_path):
    """Convert a YAML agent file to Markdown format with frontmatter."""
    
    # Read the YAML file
    with open(yaml_path, 'r') as f:
        data = yaml.safe_load(f)
    
    # Extract the main fields for frontmatter
    frontmatter = {
        'name': data.get('name', 'unnamed-agent'),
        'description': data.get('description', ''),
        'tools': ', '.join(data.get('tools', [])) if data.get('tools') else '',
    }
    
    # Add optional color field if present
    if 'color' in data:
        frontmatter['color'] = data['color']
    
    # Build the Markdown content
    md_content = "---\n"
    md_content += f"name: {frontmatter['name']}\n"
    md_content += f"description: {frontmatter['description']}\n"
    md_content += f"tools: {frontmatter['tools']}\n"
    if 'color' in frontmatter:
        md_content += f"color: {frontmatter['color']}\n"
    md_content += "---\n\n"
    
    # Add the main content sections
    md_content += "# Purpose\n\n"
    
    # Extract purpose from description or use cases
    if 'use_cases' in data:
        md_content += f"{data['description']}\n\n"
        md_content += "## Use Cases\n\n"
        for use_case in data.get('use_cases', []):
            md_content += f"- {use_case}\n"
        md_content += "\n"
    else:
        md_content += f"{data.get('description', 'Agent purpose not specified.')}\n\n"
    
    # Add instructions section
    md_content += "## Instructions\n\n"
    md_content += "When invoked, you must follow these steps:\n\n"
    
    # Add numbered instructions based on agent type
    if 'go' in frontmatter['name'].lower():
        md_content += """1. **Analyze Requirements**: Understand the specific development task and requirements.

2. **Review Existing Code**: Use Read, Grep, and Glob to examine existing codebase structure and patterns.

3. **Apply Best Practices**: Ensure all code follows language-specific best practices and idioms.

4. **Implement Solution**: Write clean, maintainable, and well-tested code.

5. **Validate and Test**: Ensure the solution works correctly and includes appropriate tests.
"""
    elif 'test' in frontmatter['name'].lower():
        md_content += """1. **Analyze Testing Requirements**: Understand what needs to be tested and coverage goals.

2. **Review Existing Tests**: Examine current test structure and patterns.

3. **Design Test Strategy**: Plan comprehensive test coverage including edge cases.

4. **Implement Tests**: Write thorough unit, integration, and end-to-end tests as needed.

5. **Validate Coverage**: Ensure adequate test coverage and all tests pass.
"""
    elif 'security' in frontmatter['name'].lower():
        md_content += """1. **Security Analysis**: Identify potential security vulnerabilities and risks.

2. **Scan for Issues**: Check for exposed credentials, insecure patterns, and vulnerabilities.

3. **Review Best Practices**: Ensure security best practices are followed.

4. **Provide Recommendations**: Offer specific remediation steps for any issues found.

5. **Validate Fixes**: Verify that security issues have been properly addressed.
"""
    else:
        md_content += """1. **Understand the Task**: Analyze the specific requirements and context.

2. **Gather Information**: Use available tools to collect necessary information.

3. **Plan Approach**: Design a solution strategy based on best practices.

4. **Execute Solution**: Implement the solution using appropriate tools and techniques.

5. **Validate Results**: Ensure the solution meets all requirements and quality standards.
"""
    
    # Add metadata if present
    if any(k in data for k in ['version', 'author', 'created', 'tags', 'proactive']):
        md_content += "\n## Metadata\n\n"
        if 'version' in data:
            md_content += f"- **Version**: {data['version']}\n"
        if 'author' in data:
            md_content += f"- **Author**: {data['author']}\n"
        if 'created' in data:
            md_content += f"- **Created**: {data['created']}\n"
        if 'tags' in data:
            md_content += f"- **Tags**: {', '.join(data['tags'])}\n"
        if 'proactive' in data:
            md_content += f"- **Proactive**: {data['proactive']}\n"
    
    return md_content

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 convert-agents.py <yaml-file-or-directory>")
        sys.exit(1)
    
    path = Path(sys.argv[1])
    
    if path.is_file() and path.suffix in ['.yaml', '.yml']:
        # Convert single file
        output_path = path.with_suffix('.md')
        try:
            md_content = convert_yaml_to_md(path)
            with open(output_path, 'w') as f:
                f.write(md_content)
            print(f"✓ Converted {path} → {output_path}")
        except Exception as e:
            print(f"✗ Error converting {path}: {e}")
            sys.exit(1)
    
    elif path.is_dir():
        # Convert all YAML files in directory
        yaml_files = list(path.glob('**/*.yaml')) + list(path.glob('**/*.yml'))
        
        if not yaml_files:
            print(f"No YAML files found in {path}")
            sys.exit(1)
        
        converted = 0
        errors = 0
        
        for yaml_file in yaml_files:
            output_path = yaml_file.with_suffix('.md')
            try:
                md_content = convert_yaml_to_md(yaml_file)
                with open(output_path, 'w') as f:
                    f.write(md_content)
                print(f"✓ Converted {yaml_file.name} → {output_path.name}")
                converted += 1
            except Exception as e:
                print(f"✗ Error converting {yaml_file.name}: {e}")
                errors += 1
        
        print(f"\nSummary: {converted} files converted, {errors} errors")
        
        if converted > 0:
            print("\nNext steps:")
            print("1. Review the generated .md files")
            print("2. Copy them to ~/.claude/agents/")
            print("3. Remove the old .yaml files")
    
    else:
        print(f"Error: {path} is not a valid YAML file or directory")
        sys.exit(1)

if __name__ == "__main__":
    main()