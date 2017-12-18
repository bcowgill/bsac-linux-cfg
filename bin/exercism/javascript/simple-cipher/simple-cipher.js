
const alphabet = 26;
const A = 'a'.charCodeAt(0);
const Z = 'z'.charCodeAt(0);

function limit (charCode)
{
    while (charCode < A)
    {
        charCode += alphabet;
    }
    while (charCode > Z)
    {
        charCode -= alphabet;
    }
    return charCode;
}

class Cipher
{
    constructor (key = 'asduifyacsjdkhewiuydsfjkheiuufaejfhd')
    {
        if (!key || 0 === key.length || /[^a-z]/.test(key))
        {
            throw new Error('Bad key');
        }
        this.key = key;
    }

    encode (plaintext)
    {
        let cipher = '';
        for (let idx = 0; idx < plaintext.length; idx++)
        {
            const key = this.key.charCodeAt(idx % this.key.length);
            cipher += String.fromCharCode(limit(plaintext.charCodeAt(idx) - A + key));
        }
        return cipher;
    }

    decode (cipher)
    {
        let plaintext = '';
        for (let idx = 0; idx < cipher.length; idx++)
        {
            const key = this.key.charCodeAt(idx % this.key.length);
            plaintext += String.fromCharCode(limit(A + cipher.charCodeAt(idx) - key));
        }
        return plaintext;
    }
};

module.exports = Cipher;
