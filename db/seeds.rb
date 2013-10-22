# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

janitor = JobPosition.create(name: 'Janitor')
programmer = JobPosition.create(name: 'Programmer')
manager = JobPosition.create(name: 'Manager')
teacher = JobPosition.create(name: 'Teacher')
ceo = JobPosition.create(name: 'CEO')
engineer = JobPosition.create(name: 'Engineer')
agent = JobPosition.create(name: 'Sale agent')
worker = JobPosition.create(name: 'Factory worker')
student = JobPosition.create(name: 'Student')

pty = PropertyType.create(name: 'Private company (Pty)')
ltd = PropertyType.create(name: 'Public company (Ltd)')
soc = PropertyType.create(name: 'State-owned company (SOC)')
ext = PropertyType.create(name: 'External company')
inc = PropertyType.create(name: 'Personal liability company (Inc)')
npc = PropertyType.create(name: 'Non-profit company (NPC)')

netcracker = Company.create(name: 'Netcracker', vat: '10000', district: 'Oktyabrisky', property_type: ltd)
haulmont = Company.create(name: 'Haulmont', vat: '10001', district: 'Oktyabrisky', property_type: inc)
coca_cola = Company.create(name: 'Coca-cola', vat: '10002', district: 'Promislenniy', property_type: ltd)
epam = Company.create(name: 'EPAM', vat: '10003', district: 'Sovetcky', property_type: ltd)
ssau = Company.create(name: 'SSAU', vat: '10004', district: 'Oktyabrisky', property_type: soc)
greenpeace = Company.create(name: 'Greenpeace', vat: '10005', district: 'Zelesnodorozny', property_type: npc)
cskb = Company.create(name: 'CSKB', vat: '10006', district: 'Kirovsky', property_type: soc)
webzavod = Company.create(name: 'Web Zavod', vat: '10007', district: 'Leninsky', property_type: ltd)

ishkov = Employee.create(full_name: 'Dmitry Ishkov')
shabanov = Employee.create(full_name: 'Anton Shabanov')
liberzon = Employee.create(full_name: 'Olga Liberzon')
gavrilov = Employee.create(full_name: 'Andrey Gavrilov')
lezin = Employee.create(full_name: 'Ilya Lezin')
malysheva = Employee.create(full_name: 'Svetlana Malysheva')
fedkayev = Employee.create(full_name: 'Alexey Fedkayev')
ivanov = Employee.create(full_name: 'Vitaly Ivanov')
pupkin = Employee.create(full_name: 'Vasiliy Pupkin')
chayka = Employee.create(full_name: 'Pavel Chayka')
moore = Employee.create(full_name: 'Patrick Moore')
griggs = Employee.create(full_name: 'Asa Griggs')
ispravnikova = Employee.create(full_name: 'Svetlana Ispravnikova')
deryabkin = Employee.create(full_name: 'Pavel Deryabkin')
kozlov = Employee.create(full_name: 'Dmitry Kozlov')
feinberg = Employee.create(full_name: 'Andrew Feinberg')

Contract.create(company: netcracker, employee: ishkov, job_position: programmer)
Contract.create(company: netcracker, employee: fedkayev, job_position: programmer)
Contract.create(company: netcracker, employee: malysheva, job_position: programmer)
Contract.create(company: netcracker, employee: ivanov, job_position: manager)
Contract.create(company: netcracker, employee: gavrilov, job_position: teacher)
Contract.create(company: netcracker, employee: feinberg, job_position: ceo)

Contract.create(company: haulmont, employee: lezin, job_position: teacher)

Contract.create(company: epam, employee: lezin, job_position: teacher)
Contract.create(company: epam, employee: chayka, job_position: programmer)

Contract.create(company: coca_cola, employee: moore, job_position: ceo)

Contract.create(company: greenpeace, employee: griggs, job_position: ceo)
Contract.create(company: greenpeace, employee: pupkin, job_position: janitor)

Contract.create(company: cskb, employee: kozlov, job_position: ceo)
Contract.create(company: cskb, employee: pupkin, job_position: worker)

Contract.create(company: webzavod, employee: shabanov, job_position: programmer)

Contract.create(company: ssau, employee: ishkov, job_position: student)
Contract.create(company: ssau, employee: chayka, job_position: student)
Contract.create(company: ssau, employee: shabanov, job_position: student)
Contract.create(company: ssau, employee: liberzon, job_position: teacher)
Contract.create(company: ssau, employee: lezin, job_position: teacher)
Contract.create(company: ssau, employee: deryabkin, job_position: teacher)
Contract.create(company: ssau, employee: gavrilov, job_position: teacher)
Contract.create(company: ssau, employee: ispravnikova, job_position: teacher)

# use rake db:reset to fully recreate db and seeds