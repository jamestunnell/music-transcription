module Music
module Transcription

class Score
  def pack
    packed_start_meter = start_meter.to_s
    packed_mcs = Hash[ meter_changes.map do |offset,change|
      a = change.pack
      a[0] = a[0].to_s
      [offset,a]
    end ]

    packed_tcs = Hash[ tempo_changes.map do |k,v|
      [k,v.to_ary]
    end ]

    packed_parts = Hash[
      @parts.map do |name,part|
        [ name, part.pack ]
      end
    ]
    packed_prog = program.pack
    
    { "start_meter" => packed_start_meter,
      "meter_changes" => packed_mcs,
      "start_tempo" => start_tempo,
      "tempo_changes" => packed_tcs,
      "program" => packed_prog,
      "parts" => packed_parts,
    }
  end
  
  def self.unpack packing
    unpacked_start_meter = Meter.parse(packing["start_meter"])
    unpacked_mcs = Hash[ packing["meter_changes"].map do |k,v|
      v = v.clone
      v[0] = Meter.parse(v[0])
      [k, Change.from_ary(v) ]
    end ]
    
    unpacked_tcs = Hash[ packing["tempo_changes"].map do |k,v|
      [k, Change.from_ary(v)]
    end ]
    
    unpacked_parts = Hash[ packing["parts"].map do |name,packed|
      [name, Part.unpack(packed)]
    end ]
    
    unpacked_prog = Program.unpack packing["program"]
    
    new(unpacked_start_meter, packing["start_tempo"],
      meter_changes: unpacked_mcs, tempo_changes: unpacked_tcs,
      program: unpacked_prog, parts: unpacked_parts
    )    
  end
end
  
end
end