require_relative '../spec_helper'

describe 'JobPosition' do
  let(:job){build :job_position}
  it 'can be created' do
    job.name.should match /Job_\d/
  end

  it 'has unique name' do
    j = create :job_position
    j.should be_valid
    (build :job_position, name: j.name).should be_invalid
    lambda { create :job_position, name: j.name}.should raise_error
  end

  it 'must have name' do
    (build :job_position, name: '').should be_invalid
  end
end