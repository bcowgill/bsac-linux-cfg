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

const drill = 'Phrases'
const speed = 'Rapid'

const drills = {
	vowels, consonants, alphabet, words, phrases
}

const rates = {
	snail: 9,
	slow: 5,
	fast: 3,
	rapid: 2,
	speedy: 1,
	devilish: 0.5,
}

const items = drills[drill.toLowerCase()] ?? drills.alphabet

const sec = 1000
const showTime = sec * (rates[speed.toLowerCase()] ?? rates.slow)
const hideTime = sec * speed === 'speedy' ? 0 : 1
const styled = (items === drills.words || items === drills.phrases) ? 'card smaller' : 'card'
const smaller = 'card smaller2'

const title = document.getElementById('drill-title')
const card = document.getElementById('flash-card')

let cards = []

title.innerText = 'Language Drill - ' + drill + ' - ' + speed
card.className = 'card smaller'
card.innerText = 'Get ready...'

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

setInterval(function () {
	if (cards.length <= 0) {
		cards = items.map(randomWeight).sort(byWeight).map(toItems)
	}
	card.innerText = ''
	card.className = styled
	if (cards[cards.length - 1].length > out_of_it.length) {
		card.className = smaller
	}

	setTimeout(function () {
		card.innerText = cards[cards.length - 1]
		cards.pop()
	}, hideTime)
}, showTime + hideTime)
