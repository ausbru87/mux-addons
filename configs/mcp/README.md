# MCP Server Configurations

Example MCP (Model Context Protocol) server configurations for use with Mux.

## Usage

Copy the desired config file to your Mux MCP config location:

```bash
# Global (applies to all projects)
cp coder.jsonc ~/.mux/mcp.jsonc

# Per-project (overrides global for that project)
cp coder.jsonc /path/to/project/.mux/mcp.jsonc
```

You can also create a local override that won't be committed:

```bash
cp coder.jsonc /path/to/project/.mux/mcp.local.jsonc
```

## Available Configs

| File | Description |
|------|-------------|
| `coder.jsonc` | Coder-specific MCP servers |
