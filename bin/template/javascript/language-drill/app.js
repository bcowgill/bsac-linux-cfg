const alphabet_url = 'https://www.youtube.com/watch?v=C_dbN9N0pR4'
const phrase_url = 'https://www.youtube.com/watch?v=nKgveRTPWd8'
const word_url = 'https://www.youtube.com/watch?v=Iz3h3B5jBz8'

const vowels = 'AEIOU'.split('')
const consonants = 'BCDFGHJKLMNPQRSTVWXYZ'.split('')
const alphabet = [...vowels, ...consonants]
const natural = [
	'bored',
	'boring',
	'delighted',
	'weird',
	'strange',
	'call/phone me',
	'telephone',
	'drink?',
	'eat?',
	'smoke?',
	'hi',
	'goodbye',
	'baby',
	'swim',
	'drive',
	'car',
	'book',
	'can',
	'aunt',
	'yes',
	'no',
	'not me!',
	'No that\'s wrong!',
	'Don\'t know',
	'happy',
	'I\'m not happy',
	'Floor',
	'Wall',
	'Door',
	'Moving car',
	'Facing you',
	'Moving away',
	'Approaching you',
	'stand',
	'walk',
	'jump',
	'hop',
	'sit',
	'fall',
	'kneel',
	'watch',
	'look',
	'look up',
	'look down',
	'stare',
	'chilly',
	'cold',
	'freezing',
	'gentle breeze',
	'strong wind',
	'gale',
]
const words = [
	'hello',
	'bye',
	'good',
	'thanks',
	'please',
	'name',
	'me',
]
const out_of_it = "I'm staying out of it"
const phrases = [
	'Let me know',
	'Let you know',
	'Let you all know',
	'Sorry, my mind has gone blank!',
	"I don't mind",
	'Have to put up with it',
	"That's interesting",
	'Not yet',
	'Take my time',
	out_of_it,
	'Again, please',
	'Way over my head!',
	'See you later',
	'See you tomorrow',
	'See you tonight',
	'Good morning',
	'Good afternoon',
	'Good evening',
	'Good night',
	'Thank you',
]

const drills = {
	vowels, consonants, alphabet, natural, words, phrases
}
const descriptions = {
	natural: 'BSL for DUMMIES ch2',
}
const urls = {
	vowels: alphabet_url,
	consonants: alphabet_url,
	alphabet: alphabet_url,
	words: word_url,
	phrases: phrase_url,
}

const rates = {
	snail: 9,
	slow: 5,
	fast: 3,
	rapid: 2,
	speedy: 1,
	devilish: 0.5,
}

const sec = 1000
const smaller = 'card smaller2'
const smallest = 'card smaller3'

const title = document.getElementById('drill-title')
const desc = document.getElementById('description')
const link = document.getElementById('link')
const app = document.getElementById('controls')
const drillSelector = document.getElementById('drill-selector')
const speedSelector = document.getElementById('speed-selector')
const customList = document.getElementById('phrase-list')
const card = document.getElementById('flash-card')

function randomWeight(item) {
	return {
		item, weight: Math.random()
	}
}

function byWeight(less, more) {
	const order = less.weight === more.weight ? 0 : less.weight < more.weight ? -1 : 1
	return order
}

function toItems(weighted) {
	return weighted.item
}

function stripBlanks(phrase) {
	return phrase.trim().length > 0
}

function trace(item) {
	console.log('item', item)
	return item
}

function getState() {
	if ('localStorage' in window) {
		try {
			customList.value = localStorage.getItem("customList") ?? ''
		}
		catch (exception) {
		}
	}
}

function saveState(content) {
	if ('localStorage' in window) {
		try {
			localStorage.setItem("customList", content)
		}
		catch (exception) {
		}
	}
}

let timer;

function startDrill() {
	if (timer) {
		clearInterval(timer)
		timer = void 0
	}

	const drill = drillSelector.value ?? 'Phrases'
	const speed = speedSelector.value ?? 'Rapid'
	const custom = customList.value ?? ''

	//console.log('settings', drill, speed)

	if (drill === 'Custom') {
		drills.custom = custom.split("\n").filter(stripBlanks)
		if (drills.custom.length < 1) {
			drills.custom = void 0
		}
	}
	const items = drills[drill.toLowerCase()] ?? drills.alphabet
	const url = urls[drill.toLowerCase()]
	const description = descriptions[drill.toLowerCase()] ?? (url ? 'See video' : '')

	const showTime = sec * (rates[speed.toLowerCase()] ?? rates.slow)
	const hideTime = sec * speed === 'speedy' ? 0 : 1
	const styled = /^(vowels|consonants|alphabet)$/i.test(drill) ? 'card' : 'card smaller'

	let cards = []

	title.innerText = 'Language Drill - ' + drill + ' - ' + speed
	if (url) {
		desc.innerText = ''
		link.innerText = description
		link.href = url
	}
	else {
		desc.innerText = description
		link.innerText = ''
		link.href = '#'
	}
	card.className = 'card smaller'
	card.innerText = 'Get ready...'

	timer = setInterval(function () {
		if (cards.length <= 0) {
			cards = items.map(randomWeight).sort(byWeight).map(toItems)
		}
		card.innerText = ''
		card.className = styled
		const next = cards[cards.length - 1].length
		if (next > 2 * out_of_it.length) {
			card.className = smallest
		}
		else if (next > out_of_it.length) {
			card.className = smaller
		}

		const drillNow = drillSelector.value ?? 'Phrases'
		const speedNow = speedSelector.value ?? 'Rapid'
		const customNow = customList.value ?? ''
		if ( drill !== drillNow || speed !== speedNow || custom !== customNow) {
			saveState(customNow)
			startDrill()
		}

		setTimeout(function () {
			card.innerText = cards[cards.length - 1]
			cards.pop()
		}, hideTime)
	}, showTime + hideTime)
}

function main() {
	// Show initially hidden app section
	app.className = ''
	getState()
	startDrill()
}

main()