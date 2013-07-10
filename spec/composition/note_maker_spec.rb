require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::NoteMaker do
  describe '.monophonic_note' do
    it 'should produce a single monophonic note' do
      { [0.25, C4] => note(0.25, [interval(C4)]),
        [0.75, F3] => note(0.75, [interval(F3)]),
        [-0.125, F3] => note(0.125),
        [Rational(2,3), Gb2] => note(Rational(2,3), [interval(Gb2)]),
        [Rational(1,10), D5] => note(Rational(1,10), [interval(D5)]),
      }.each do |inputs, expected_note|
        duration, pitch = *inputs
        note = NoteMaker.monophonic_note duration, pitch
        note.should eq(expected_note)
      end
    end
  end

  describe '.polyphonic_note' do
    it 'should produce a single polyphonic note' do
      { [0.25, [C4,D4]] => note(0.25, [interval(C4), interval(D4)]),
        [0.75, [F3, Db2, G5]] => note(0.75, [interval(F3), interval(Db2), interval(G5)]),
        [Rational(2,3), [Gb2]] => note(Rational(2,3), [interval(Gb2)]),
        [-0.25, [G2]] => note(0.25)
      }.each do |inputs, expected_note|
        duration, pitches = *inputs
        note = NoteMaker.polyphonic_note duration, pitches
        note.should eq(expected_note)
      end
    end
  end

  describe '.monophonic_notes' do
    it 'should produce multiple monophonic notes' do
      { [[0.25,0.125], [C4,D4,A3]] => [ note(0.25, [interval(C4)]), note(0.125, [interval(D4)]), note(0.25, [interval(A3)])],
        [[0.75,-0.25, 0.125], [F3, Db2, G5, B5]] => [ note(0.75, [interval(F3)]), note(0.25), note(0.125, [interval(G5)]), note(0.75, [interval(B5)])],
      }.each do |inputs, expected_note|
        rhythm, pitches = *inputs
        note = NoteMaker.monophonic_notes rhythm, pitches
        note.should eq(expected_note)
      end
    end    
  end

  describe '.polyphonic_note' do
    it 'should produce multiple polyphonic notes' do
      { [[0.25,0.125], [[C4,D4],[A3]]] => [ note(0.25, [interval(C4), interval(D4)]), note(0.125, [interval(A3)])],
        [[0.75,-0.25], [[F3], [Db2], [G5,B5]]] => [note(0.75, [interval(F3)]), note(0.25), note(0.75, [interval(G5), interval(B5)])],
      }.each do |inputs, expected_note|
        rhythm, pitch_groups = *inputs
        note = NoteMaker.polyphonic_notes rhythm, pitch_groups
        note.should eq(expected_note)
      end
    end
  end


end
