---
layout: post
title: "Build an AI Researcher: Flask API for Deep Analysis with Gemini"
date: "2024/04/05 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/ai-researcher/header.jpg"
post_image_height: 300
image: "/assets/images/blog/ai-researcher/header.jpg"
tags: flask api gemini google-ai python search-integration
categories: python
permalink: /blog/:title
description: Learn how to build a powerful backend API using Flask, Google's Gemini, and DuckDuckGo Search to create an AI research assistant capable of understanding, researching, and conversing about complex topics.
---

Ever wanted to build an application that doesn't just *store* information, but can *understand*, *research*, and *converse* about it? The rise of powerful Large Language Models (LLMs) like Google's Gemini makes this more accessible than ever.

But what if you want your AI to have access to up-to-the-minute information from the web? That's where combining an LLM with a search engine comes in handy!

In this post, we'll walk step-by-step through creating a powerful backend API using Flask, Google Gemini, and DuckDuckGo Search. This API will be able to:

1. Chat conversationally, remembering context.
2. Optionally perform web searches to inform its chat responses.
3. Handle direct queries, using web search results to generate detailed answers.

## Prerequisites

Before we start, make sure you have:

1. Python 3.7+ installed
2. A Google API key for Gemini (get one at [Google AI Studio](https://makersuite.google.com/app/apikey))
3. Basic knowledge of Python and REST APIs

## Step 1: Project Setup & Dependencies

Let's start by setting up our project and installing the necessary dependencies:

```bash
# Create project directory
mkdir ai-researcher-api
cd ai-researcher-api

# Create a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install flask flask-cors google-generativeai duckduckgo-search python-dotenv
```

Now, create a `.env` file to store your API key:

```bash
# .env file
GOOGLE_API_KEY=your_google_api_key_here
```

## Step 2: Building the Flask App (app.py)

Let's build our Flask application with the necessary imports and configuration:

```python
import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
import google.generativeai as genai
from duckduckgo_search import DDGS

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Configure Google Gemini API
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
model = genai.GenerativeModel('gemini-pro')

# Initialize conversation history
conversation_history = []

# DuckDuckGo search client
ddgs = DDGS()
```

### Imports and Initial Setup:

First, we import all necessary modules and initialize our Flask app with CORS support to allow cross-origin requests. We load our environment variables and configure the Google Gemini API with our key.

### DuckDuckGo Search Integration:

This module allows us to perform web searches programmatically without being blocked. We'll use it to get up-to-date information for our AI assistant.

## Step 3: Helper for Query Endpoint Prompting:

Now, let's create a helper function to format search results into meaningful context for our AI:

```python
def format_search_results(query, results, max_results=5):
    """Format search results into a prompt for the AI model."""
    formatted_results = "\n\n".join([
        f"Title: {result['title']}\nSource: {result['href']}\nContent: {result['body']}"
        for result in results[:max_results]
    ])
    
    prompt = f"""
    USER QUERY: {query}
    
    SEARCH RESULTS:
    {formatted_results}
    
    Based ONLY on the search results above, provide a comprehensive answer to the user's query.
    If the search results don't contain relevant information, acknowledge this fact and provide
    a general response based on your knowledge.
    """
    return prompt
```

This function takes search results and formats them in a way that helps the AI focus on providing accurate information from those results.

## Step 4: Flask API Endpoints:

Let's implement our API endpoints:

```python
@app.route('/api/chat', methods=['POST'])
def chat_endpoint():
    """Endpoint for conversational chat with memory."""
    global conversation_history
    
    data = request.json
    user_message = data.get('message', '')
    use_search = data.get('use_search', False)
    
    # Optionally perform a web search to inform the response
    search_context = ""
    if use_search:
        try:
            search_results = list(ddgs.text(user_message, max_results=3))
            if search_results:
                search_context = "The following information might be helpful:\n\n"
                for result in search_results:
                    search_context += f"- {result['body']}\n\n"
        except Exception as e:
            print(f"Search error: {e}")
    
    # Add user message to conversation history
    conversation_history.append({'role': 'user', 'parts': [user_message]})
    
    # If we have search context, add it
    if search_context:
        conversation_history.append({'role': 'model', 'parts': [f"I've found some relevant information:\n{search_context}"]})
    
    # Generate response
    chat = model.start_chat(history=conversation_history)
    response = chat.send_message(search_context + user_message if search_context else user_message)
    
    # Add model response to conversation history
    conversation_history.append({'role': 'model', 'parts': [response.text]})
    
    # Keep conversation history manageable (last 10 exchanges)
    if len(conversation_history) > 20:
        conversation_history = conversation_history[-20:]
    
    return jsonify({
        'response': response.text,
        'used_search': bool(search_context)
    })

@app.route('/api/query', methods=['POST'])
def query_endpoint():
    """Endpoint for direct queries that uses web search results."""
    data = request.json
    query = data.get('query', '')
    
    # Perform web search
    try:
        search_results = list(ddgs.text(query, max_results=5))
        prompt = format_search_results(query, search_results)
        
        # Generate response based on search results
        response = model.generate_content(prompt)
        return jsonify({
            'response': response.text,
            'search_results': search_results[:5]  # Include top 5 search results
        })
    except Exception as e:
        return jsonify({
            'error': f"An error occurred: {str(e)}",
            'response': model.generate_content(f"I couldn't search for '{query}', but I'll try to answer: {query}").text
        })

@app.route('/api/reset', methods=['POST'])
def reset_conversation():
    """Reset the conversation history."""
    global conversation_history
    conversation_history = []
    return jsonify({'status': 'Conversation history cleared'})

if __name__ == '__main__':
    app.run(debug=True, port=5000)
```

### Chat Endpoint:
- Maintains conversation history for context
- Optionally performs web searches to inform responses
- Keeps history manageable by limiting to 10 exchanges

### Query Endpoint:
- Performs web searches for the query
- Formats search results as context for the AI
- Generates a response based on search findings
- Falls back to general knowledge if search fails

### Reset Endpoint:
- Provides a way to clear conversation history and start fresh

## Step 5: Run The API

Save the file as `app.py` and run it:

```bash
python app.py
```

Your API should now be running on `http://localhost:5000` and accessible through the three endpoints we created.

## Testing Our API

You can test the API using curl or Postman. Here's an example using curl:

```bash
# Test the chat endpoint
curl -X POST http://localhost:5000/api/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "What are the latest developments in quantum computing?", "use_search": true}'

# Test the query endpoint
curl -X POST http://localhost:5000/api/query \
  -H "Content-Type: application/json" \
  -d '{"query": "What is the current status of GPT-5 development?"}'

# Reset the conversation
curl -X POST http://localhost:5000/api/reset
```

## Potential Enhancements

Here are a few ways you could enhance this API:

1. **Authentication**: Add JWT or API key authentication to secure your endpoints
2. **Rate Limiting**: Implement rate limiting to prevent abuse
3. **Streaming Responses**: Implement streaming for long responses
4. **Multiple Conversation Contexts**: Support multiple users with separate conversation histories
5. **Additional Search Sources**: Add more search engines or specialized sources (e.g., academic papers)

## Conclusion

You've just built a powerful AI research assistant backend using Flask, Google's Gemini API, and DuckDuckGo Search. This API can understand queries, research information, and carry on contextual conversations.

The combination of an LLM with search capabilities gives your AI application both deep understanding and up-to-date knowledge—a powerful combination for building truly useful AI tools.

For production deployment, consider containerizing this with Docker and deploying to a cloud provider like Google Cloud Run or AWS Lambda.

Happy coding! 