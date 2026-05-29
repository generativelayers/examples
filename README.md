# Generative Layers — Examples

[![Maven Central](https://img.shields.io/maven-central/v/com.generativelayers/generative-layers-core?color=blue&label=Maven%20Central)](https://central.sonatype.com/artifact/com.generativelayers/generative-layers-core)

Example projects demonstrating Generative Layers integrations across three BDI agent platforms.

## Projects

| Platform | Example | Description |
|---|---|---|
| **ASTRA** | [single-agent-candidate](astra/single-agent-candidate) | Basic LLM invocation with candidate adoption |
| **ASTRA** | [fipa-request-gl](astra/fipa-request-gl) | Multi-agent FIPA-Request with GL governance |
| **ASTRA** | [invalid-output-rejection](astra/invalid-output-rejection) | Schema validation & output rejection handling |
| **Jason** | [single-agent-candidate](jason/single-agent-candidate) | Basic LLM invocation with candidate adoption |
| **Jason** | [invalid-output-rejection](jason/invalid-output-rejection) | Schema validation & output rejection handling |
| **JaCaMo** | [single-agent-candidate](jacamo/single-agent-candidate) | Artifact-based LLM invocation with observable properties |

## Prerequisites

- Java 17+
- Maven 3.9+
- A Gemini or OpenAI API key

## Running an Example

```bash
# 1. Set your API key
export GEMINI_API_KEY="your-key"

# 2. Navigate to any example
cd jason/single-agent-candidate

# 3. Build and run
mvn clean compile exec:java
```

## Dependency

All examples use the published Maven Central artifact:

```xml
<dependency>
    <groupId>com.generativelayers</groupId>
    <artifactId>generative-layers-core</artifactId>
    <version>0.1.0</version>
</dependency>
```

## Learn More

📖 [Documentation](https://www.generativelayers.com/framework.html)  
🏗️ [Framework source](https://github.com/generativelayers/framework)
