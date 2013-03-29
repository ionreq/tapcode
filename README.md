tapcode
=======

all sources concerning tap code.

at the moment there is only one, namely a comparison of code efficiency of the tap code and various others.

for the results see the output.txt

testtext.txt was Franz Kafka, "Der Bau" from here: http://www.digbib.org/Franz_Kafka_1883/

letters are converted to lower case, space is considered a character, i.e. it gets a code and a frequency.
four german umlauts are included, everything else is ignored, so that there are 31 different codes in the end.
a huffman encoding is calculated and it turns out that the text can be encoded with an average of 4.2 bits per character.
this code is of course not practical for humans to use.

the next code is simply a 5 bit per character encoding, which is also impractical to use.
5 bit because 2^5=32 and we have 31 chars to encode, the code 00000 is not used.

next is the tap code which turns out to have ca. 6 bit efficiency which i'm very glad about.
considering that most codelets have 3 bits fixed, i.e. the first bit is 1 and the last two 0, this is an awesome result.

with morse code there is a problem: the pure bit efficiency is very high, over 8 bit, but:
in practice, a dit would correspond to a tap in the tap code, so for comparing efficency in reality, one would have to halve the bit efficiency.
this is due to the fact that dit and dah are really two different sounds,
and the premise of the tap code was that you can't have that, but only one single sound.
so, i'm not quite sure how to interpret this result, maybe this just shows that morse and tap code are not really comparable.

the polybius square in its original form has an efficiency of around 7.7
and this compares well with the tap code.
it can be made more efficient by assigning the short codes to the more frequent letters,
and by using the diagonals which correspond to constant code length instead of just filling the square.
then the efficiency increases to 6.5 bit which is quite good, compared to the 6 bit of the tap code.
note however that this optimized polybius square tap code is not very much easier to learn than my tap code.
so if you are willing to learn a tap code, mine is still the best choice.


