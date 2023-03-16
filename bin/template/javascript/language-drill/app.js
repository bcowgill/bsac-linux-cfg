const alphabet_url = 'https://www.youtube.com/watch?v=C_dbN9N0pR4'
const phrase_url = 'https://www.youtube.com/watch?v=nKgveRTPWd8'
const word_url = 'https://www.youtube.com/watch?v=Iz3h3B5jBz8'

const vowels = 'AEIOU'.split('')
const consonants = 'BCDFGHJKLMNPQRSTVWXYZ'.split('')
const alphabet = [...vowels, ...consonants]
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
	vowels, consonants, alphabet, words, phrases
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

const title = document.getElementById('drill-title')
const link = document.getElementById('link')
const app = document.getElementById('controls')
const drillSelector = document.getElementById('drill-selector')
const speedSelector = document.getElementById('speed-selector')
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

function trace(item) {
	console.log('item', item)
	return item
}


let timer;

app.className = ''

function startDrill() {
	if (timer) {
		clearInterval(timer)
		timer = void 0
	}

	const drill = drillSelector.value ?? 'Phrases'
	const speed = speedSelector.value ?? 'Rapid'

	//console.log('settings', drill, speed)

	const items = drills[drill.toLowerCase()] ?? drills.alphabet
	const url = urls[drill.toLowerCase()] ?? urls.alphabet

	const showTime = sec * (rates[speed.toLowerCase()] ?? rates.slow)
	const hideTime = sec * speed === 'speedy' ? 0 : 1
	const styled = (items === drills.words || items === drills.phrases) ? 'card smaller' : 'card'

	let cards = []

	title.innerText = 'Language Drill - ' + drill + ' - ' + speed
	link.innerText = 'Learn these from video'
	link.href = url
	card.className = 'card smaller'
	card.innerText = 'Get ready...'

	timer = setInterval(function () {
		if (cards.length <= 0) {
			cards = items.map(randomWeight).sort(byWeight).map(toItems)
		}
		card.innerText = ''
		card.className = styled
		if (cards[cards.length - 1].length > out_of_it.length) {
			card.className = smaller
		}

		const drillNow = drillSelector.value ?? 'Phrases'
		const speedNow = speedSelector.value ?? 'Rapid'
		if ( drill !== drillNow || speed !== speedNow) {
			startDrill()
		}

		setTimeout(function () {
			card.innerText = cards[cards.length - 1]
			cards.pop()
		}, hideTime)
	}, showTime + hideTime)
}

startDrill()
