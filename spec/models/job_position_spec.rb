require_relative '../spec_helper'

describe 'JobPosition' do
  let(:job){build :job_position}
  it 'can be created' do
    job.name.should match /Job_\d/
  end
end