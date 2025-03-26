/*
    Github Copilot created this code with some simple text prompts:

    - create a parametric Queue class of type T with join, serve, length and
    process functions.
    - add jsdoc documentation.
  - where possible each method should return this so functions can be chained,
    change the code and documentation.
    - add code comments to the functions.
  - add a split queue function which will move the first half of the waiting
    items to another queue provided.
    - rename split function to switchQueues and move the final half of the queue
    there.
    - add a label about each console message telling what is going on.
    - change switchQueues to preserve the order of the last half of the queue when
    it moves.
    - add a peek function which returns the next item that will be served but
    leaves it in the queue.

    then...
    - write a simulator where items arrive with normal distribution every 5
    minutes.  once 30 items arrive no more should be added.  start with two
    queues which process each item in 10 minutes normal distribution.  once a
    queue has 10 items waiting start another queue and switch the items there.
    open at most 6 queues. run the simulation and print out how long it takes to
    process 30 items.
*/

/**
 * A generic Queue class.
 * @template T - The type of elements in the queue.
 */
export class Queue<T> { // Export the Queue class
    private items: T[] = [];

    /**
     * Returns the number of items in the queue.
     * @returns {number} - The number of items in the queue.
     */
    length(): number {
        // Return the length of the items array
        return this.items.length;
    }

    /**
     * Adds an item to the end of the queue.
     * @param {T} item - The item to add.
     * @returns {this} - The current instance of the Queue.
     */
    join(item: T): this {
        // Push the item to the end of the items array
        this.items.push(item);
        // Return the current instance to allow chaining
        return this;
    }

    /**
     * Returns the next item that will be served but leaves it in the queue.
     * @returns {T | undefined} - The next item that will be served, or undefined if the queue is empty.
     */
    peek(): T | undefined {
        // Return the first item from the items array without removing it
        return this.items[0];
    }

    /**
     * Removes and returns the item at the front of the queue.
     * @returns {T | undefined} - The item at the front of the queue, or undefined if the queue is empty.
     */
    serve(): T | undefined {
        // Remove and return the first item from the items array
        return this.items.shift();
    }

    /**
     * Processes each item in the queue using the provided callback function until the queue is empty.
     * @param {(item: T) => void} callback - The callback function to process each item.
     * @returns {this} - The current instance of the Queue.
     */
    process(callback: (item: T) => void): this {
        // Continue processing while there are items in the queue
        while (this.items.length > 0) {
            // Serve the item at the front of the queue
            const item = this.serve();
            // If the item is not undefined, process it with the callback
            if (item !== undefined) {
                callback(item);
            }
        }
        // Return the current instance to allow chaining
        return this;
    }

    /**
     * Switches the queue, moving the final half of the items to another queue.
     * @param {Queue<T>} targetQueue - The queue to move the final half of the items to.
     * @returns {this} - The current instance of the Queue.
     */
    switchQueues(targetQueue: Queue<T>): this {
        // Calculate the number of items to move
        const halfLength = Math.ceil(this.items.length / 2);
        // Create a temporary array to hold the items to be moved
        const itemsToMove: T[] = [];
        // Move the final half of the items to the temporary array
        for (let i = 0; i < halfLength; i++) {
            const item = this.items.pop();
            if (item !== undefined) {
                itemsToMove.unshift(item); // Preserve order by adding to the front
            }
        }
        // Move the items from the temporary array to the target queue
        for (const item of itemsToMove) {
            targetQueue.join(item);
        }
        // Return the current instance to allow chaining
        return this;
    }
}
/*
// Example usage:
const queue = new Queue<number>();
queue.join(1).join(2).join(3).join(4);

// Log the length of the queue after adding four items
console.log("Queue length after joining 4 items:", queue.length()); // Output: 4

const newQueue = new Queue<number>();
queue.switchQueues(newQueue);

// Log the length of both queues after switching the final half of the items
console.log("Queue length after switching final half to newQueue:", queue.length()); // Output: 2
console.log("NewQueue length after receiving final half of items:", newQueue.length()); // Output: 2

// Process and log each item in the original queue
queue.process(item => {
    console.log("Processing item from queue:", item); // Output: 1, 2
});

// Process and log each item in the new queue
newQueue.process(item => {
    console.log("Processing item from newQueue:", item); // Output: 3, 4
});

// Log the length of both queues after processing all items
console.log("Queue length after processing all items:", queue.length()); // Output: 0
console.log("NewQueue length after processing all items:", newQueue.length()); // Output: 0

*/