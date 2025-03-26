/*
    Github Copilot created this code with a text prompt:
    - write a simulator where items arrive with normal distribution every 5
    minutes.  once 30 items arrive no more should be added.  start with two
    queues which process each item in 10 minutes normal distribution.  once a
    queue has 10 items waiting start another queue and switch the items there.
    open at most 6 queues. run the simulation and print out how long it takes to
    process 30 items.

    One problem was it imported mathjs to use randomNormal() function which didn't
    exist. After a bit of searching I found random-normal module which did the
    trick.

    The run function isn't quite right in that it adds everyone to the queues
    before trying to process all the queues. Instead it should probably create a
    random arrival time and processing time for each person and keep them in
    another queue. Pull one off that input queue and add to the cashier queue and
    adjust the clock. Probably need more queue functions though like a peek to see
    how much processing time the first one in the queue needs. and rather then
    processing everyone do one at a time. adding new arrivals as the clock counts
    up and processing items at the front which land within that time slice.

    Output:
    Total time to process 30 items: 440.94 minutes
    Average time to process each item 14.70 minutes
*/

import randomNormal from 'random-normal';
import { Queue } from './queue.ts'; // Adjust the import path as necessary

class Simulator {
    private queues: Queue<number>[] = [];

    private maxQueues: number = 6;
    private maxItems: number = 30;
    private splitLength: number = 10; // items in queue before new queue opens

    private arrivalInterval: number = 5; // minutes
    private arrivalIntervalDev: number = 1; // minutes
    private processTimeMean: number = 10; // minutes
    private processTimeDev: number = 2; // minutes

    private itemsProcessed: number = 0;
    private currentTime: number = 0; // minutes

    private decimals: number = 2; // decimal places on number output

    constructor() {
        // Initialize with one queue
        this.queues.push(new Queue<number>());
    }

    /**
     * Generates a random number based on a normal distribution.
     * @param {number} mean - The mean value of the distribution.
     * @param {number} stdDev - The standard deviation of the distribution.
     * @returns {number} - A random number based on the normal distribution.
     */
    private normalDistribution(mean: number, stdDev: number): number {
        return randomNormal({ mean, dev: stdDev });
    }

    /**
     * Adds an item to the appropriate queue or starts a new queue if necessary.
     * @param {number} item - The item to add to the queue.
     */
    private addItemToQueue(item: number): void {
        // Try to add the item to an existing queue with less than 10 items
        for (const queue of this.queues) {
            if (queue.length() < this.splitLength) {
                queue.join(item);
                return;
            }
        }
        // If all queues are full and maxQueues is not reached, start a new queue
        if (this.queues.length < this.maxQueues) {
            const newQueue = new Queue<number>();
            this.queues[this.queues.length - 1].switchQueues(newQueue);
            newQueue.join(item);
            this.queues.push(newQueue);
        } else {
            // If all queues are full, add to the first queue
            this.queues[0].join(item);
        }
    }

    /**
     * Processes items in all queues and updates the total processing time.
     */
    private processQueues(): void {
        for (const queue of this.queues) {
            queue.process(item => {
                this.itemsProcessed++;
                this.currentTime += this.normalDistribution(this.processTimeMean, this.processTimeDev);
            });
        }
    }

    /**
     * Runs the simulation, simulating the arrival and processing of items.
     */
    public run(): void {
        let itemCount = 0;
        // Simulate the arrival of items
        while (itemCount < this.maxItems) {
            this.currentTime += this.normalDistribution(this.arrivalInterval, this.arrivalIntervalDev);
            this.addItemToQueue(itemCount);
            itemCount++;
        }
        // Process all items in the queues
        this.processQueues();
        // Print the total time taken to process all items
        console.log(`Total time to process ${this.maxItems} items: ${this.currentTime.toFixed(this.decimals)} minutes`);
        console.log(`Average time to process each item ${(this.currentTime / this.maxItems).toFixed(this.decimals)} minutes`);
    }
}

// Run the simulation
const simulator = new Simulator();
simulator.run();