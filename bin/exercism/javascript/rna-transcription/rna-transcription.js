
const Dna2Rna = {
    A: 'U',
    C: 'G',
    G: 'C',
    T: 'A',
};

const DnaTranscriber = function () {};

DnaTranscriber.prototype.toRna = function (strand = '')
{
    return strand.split('')
        .map((nucleotide) => {
            const rna = Dna2Rna[nucleotide];
            if (!rna)
            {
                throw new Error('Invalid input');
            }
            return rna;
        })
        .join('');
};

module.exports = DnaTranscriber;
