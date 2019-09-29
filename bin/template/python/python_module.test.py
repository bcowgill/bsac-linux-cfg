#!/usr/bin/env python

import unittest

class IntegerArithmeticTestCase(unittest.TestCase):
    """integer arithmetic test case"""
    def testAdd(self):  ## test method names begin 'test*'
        """it should add integers together"""
        print '\n', self.shortDescription()
        #self.skipTest('skip always')
        self.assertEqual((1 + 2), 3)
        self.assertEqual(0 + 1, 1)

    def testMultiply(self):
        """it should multiply integers together"""
        print '\n', self.shortDescription()
        self.assertEqual((0 * 10), 0)
        self.assertEqual((5 * 8), 40)

    def testAssertions(self):
        """it should test the various assertion types"""
        print '\n', self.shortDescription()

        with self.assertRaises(ZeroDivisionError):
            # change to 10 or '0' to make fail.
            32 / 0 # expecting ZeroDivisionError

        with self.assertRaisesRegexp(ZeroDivisionError, 'integer'):
            42 / 0 # expecting ZeroDivisionError matches 'integer'

        a = {}
        b = {}
        c = a
        self.assertAlmostEqual(1.333, 1.332, 2) # decimal places
        self.assertAlmostEquals(1.36, 1.32, None, None, 0.05) # delta
        self.assertDictContainsSubset({'a':2, 'b':4}, {'a':2, 'b':4, 'c': True})
        self.assertDictEqual({'a': 43},{'a': 43})
        self.assertEqual({}, {})
        self.assertEquals(False, 0)
        self.assertFalse(None)
        self.assertFalse(False)
        self.assertFalse(0)
        self.assertFalse('')
        self.assertFalse({})
        self.assertFalse([])
        self.assertFalse((0))
        self.assertGreater(4.2, 4)
        self.assertGreaterEqual(4.2, 4)
        self.assertIn(56, [1,2,3,56])
        self.assertIs(a,c)
        self.assertIsInstance(42.0, float)
        self.assertIsNone(None)
        self.assertItemsEqual([0, 1, 1], [1, 0, 1]) # same items, any order
        self.assertLess(4, 4.1)
        self.assertLessEqual(4, 4.2)
        self.assertListEqual([1,2], [1,2])
        self.assertMultiLineEqual('one\ntwo\n', 'one\ntwo\n')
        self.assertRegexpMatches('match me', '^match')
        self.assertSequenceEqual((1,2), (1,2), None, tuple) # omit msg (None) to get diff results
        self.assertSetEqual(set((1,2)), set((1,2))) # omit msg to get diff results
        self.assertTrue(True)
        self.assertTrue(1)
        self.assertTrue(' ')
        self.assertTrue({'a':0})
        self.assertTrue([None])
        self.assertTrue((1))
        self.assertTupleEqual((1,2), (1,2)) # omit msg to get diff results

        self.assertIsNot(4, 54)
        self.assertIsNotNone(7)
        self.assertNotAlmostEqual(1.333, 1.323, 2) # decimal places
        self.assertNotAlmostEquals(1.36, 1.3, None, None, 0.05) # delta
        self.assertNotEqual({ 'a': 1 }, { 'a': 2 })
        self.assertNotEquals({ 'a': 1 }, { 'a': 2 })
        self.assertNotIn(15, [14])
        self.assertNotIsInstance(42, float)
        self.assertNotRegexpMatches('match me', '^MATCH')

if __name__ == '__main__':
    unittest.main()
