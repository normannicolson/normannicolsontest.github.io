# Twilio Sms Retrieval Api

July 2025

> NodeJs application that retrieves the last sms received from Twilio, containerized with Docker for easy use.

Useful for automating Azure B2c policies

## Create 

```
npm init
```

Add twilio dependency 

```
npm install twilio --save-dev
```

```
{
  "name": "smsclient",
  "version": "1.0.0",
  "description": "npm init",
  "main": "index.js",
  "dependencies": {
    ...
    "twilio": "^5.5.2",
  },
  "scripts": {
    "dev": "node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}

```

Create Environment Variables

Create a `.env` file in the project root with the following variables:

.env file 
```
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_PHONE_NUMBER=
PORT=3001
```

Create index.js

```
import express from 'express';
import dotenv from 'dotenv';
import twilio from 'twilio';

const app = express();
dotenv.config();
const PORT = process.env.PORT || 3000;

const twilioClient = new twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

app.get('/sms/recent', async (req, res) => {

  try {

    // Calculate timestamp for 30 seconds ago
    const oneMinuteAgo = new Date(Date.now() - (60 * 1000));
    const dateSentAfter = oneMinuteAgo.toISOString();

    // Fetch messages sent to your Twilio number in the last minute
    const messages = await twilioClient.messages.list({
      to: process.env.TWILIO_PHONE_NUMBER,
      dateSentAfter: dateSentAfter,
    });

    if (messages.length > 0) {
      // Sort messages by date sent (newest first)
      messages.sort((a, b) => new Date(b.dateSent) - new Date(a.dateSent));
          
      // Get the most recent message
      const latestMessage = messages[0];

      return res.status(200).json({
        success: true,
        message: 'Latest SMS message.',
        data: {
          messageSid: latestMessage.sid,
          from: latestMessage.from,
          body: latestMessage.body,
          dateSent: latestMessage.dateSent
        }
      });
    }
    else
    {
      return res.status(404).json({
        success: false,
        message: 'No recent SMS messages.',
        data: null
      });
    }
  } 
  catch (error) {

    return res.status(500).json({
      success: false,
      message: 'Error retrieving recent SMS messages.',
      error: error.message
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

Create Dockerfile 

Dockerfile file 
```
# Use official Node.js runtime as base image
FROM node:24-alpine

# Set working directory in container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available) into /usr/src/app
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy application code into /usr/src/app
COPY . .

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Change ownership of the app directory to nodejs user
RUN chown -R nodejs:nodejs /usr/src/app
USER nodejs

# Expose port (adjust if your app uses a different port)
EXPOSE 3000

# Command to run the application
CMD ["node", "index.js"]
```

## Docker

Build image

```bash
docker build --no-cache --progress=plain -t sms-client . 
```

Run with Docker

```bash
docker run -e TWILIO_ACCOUNT_SID=<> -e TWILIO_AUTH_TOKEN=<> -e TWILIO_PHONE_NUMBER=<> -e PORT=3000 -p <LocalPort>:3000 sms-client
```

## Local Development

```
npm install
npm run dev
```

or

```
npm install
node index.js
```

Usage

Once the application is running, it will be available at:
- Local: `http://localhost:3001/sms/recent` (or your configured PORT)
- Docker: `http://localhost:3001/sms/recent`

The application will automatically retrieve and process the last sms received from Twilio.

## Docker Commands

**Build the image:**
```bash
docker build -t sms-client .
```

**Run with environment file:**
```bash
docker run --env-file .env -p 3000:3000 sms-client
```

**Run with individual environment variables:**
```bash
docker run \
  -e TWILIO_ACCOUNT_SID=your_sid \
  -e TWILIO_AUTH_TOKEN=your_token \
  -e TWILIO_PHONE_NUMBER=your_number \
  -e PORT=3000 \
  -p 3000:3000 \
  sms-client
```

**View logs:**
```bash
docker logs <container_id>
```
