// @ts-ignore
import {Message} from "./messages.ts";

export class Websocket {
    constructor(id, receiveCallback) {
        this.receiveCallback = receiveCallback;

        // Create WebSocket connection.
        // JavaScript doesn't seem to want to send tokens, so we have to do it junkily like that
        this.socket = new WebSocket(`ws://localhost:8080/ws/${id}`);
        this.socket.binaryType = 'arraybuffer';

        // Listen for messages
        this.socket.addEventListener('message', (event) => {
            if (this.receiveCallback == null ||
                !event.data) {
                return;
            }

            const message = Message.deserializeBinary(new Uint8Array(event.data));
            this.receiveCallback(message);
        });

    }

    close() {
        this.socket.close();
    }

    sendMessage(message) {
        let bytes = message.serializeBinary();
        this.socket.send(bytes);
    }
}