// Checks the bundled TeamPulse site from inside the app. Run with: TeamPulse.app/Contents/MacOS/TeamPulse --selftest
// It walks the real journeys: landing page, team leader registration, adding a member, the member's first sign-in.
// Each step reports on its own line, so a failure says exactly what broke.
const out = [];
const wait = ms => new Promise(r => setTimeout(r, ms));
const ok = m => out.push('ok: ' + m);
const fail = m => out.push('FAIL: ' + m);
const step = async (name, fn) => {
  try { await fn(); } catch (e) { fail(name + ' (' + (e && e.message ? e.message : e) + ')'); }
};
const frameDoc = () => document.querySelector('#appframe').contentDocument;
const frameWin = () => document.querySelector('#appframe').contentWindow;
const fill = (form, values) => { for (const [k, v] of Object.entries(values)) form.elements[k].value = v; form.requestSubmit(); };

try { localStorage.clear(); } catch (e) {}

await step('landing page', async () => {
  document.title === 'TeamPulse' ? ok('landing page loads') : fail('title is ' + document.title);
});

await step('no download buttons inside the desktop app', async () => {
  const s = document.getElementById('download');
  (!s || s.hidden) ? ok('the download section is hidden inside the desktop app') : fail('the desktop app still shows the download section');
});

await step('the app opens on its own sign-in page', async () => {
  document.querySelector('a[href="app.html"]').click();
  await wait(1600);
  const d = frameDoc();
  if (!d) { fail('the app frame cannot be read'); return; }
  (d.querySelector('[data-form=signin]') && !d.querySelector('.shell')) ? ok('the app opens on its own sign-in page (no dashboard behind it)') : fail('the app did not open on the sign-in page');
});

await step('the logo returns to the landing page', async () => {
  frameDoc().querySelector('a.brand').click();
  await wait(500);
  document.querySelector('#appview').hidden ? ok('the logo returns to the landing page') : fail('the logo did not return');
});

await step('the sign-in card hands the ID to the app', async () => {
  const f = document.querySelector('#si');
  f.elements.id.value = '06OW209';
  f.requestSubmit();
  await wait(1700);
  const pre = frameDoc().querySelector('#si-id');
  pre && pre.value === '06OW209' ? ok('the sign-in card hands the ID to the app') : fail('the sign-in ID was not handed over');
});

await step('team leader registration', async () => {
  location.hash = '';
  await wait(400);
  location.hash = 'app-register';
  await wait(1400);
  const reg = frameDoc().querySelector('[data-form=register]');
  if (!reg) { fail('the registration page did not open'); return; }
  fill(reg, { name: 'Self Test', team: 'Test Team', email: 'selftest@example.com', neo: '063-1000001', p1: 'Secret2026', p2: 'Secret2026' });
  await wait(900);
  frameDoc().querySelector('.auth-card h1').textContent === 'Check your email' ? ok('registration asks the leader to confirm their email') : fail('registration did not reach the email step');
});

await step('email confirmation creates the team', async () => {
  const w = frameWin();
  w.TP.openCta(w.TP.mail()[0].id);
  await wait(500);
  const leader = w.TP.me();
  (leader && leader.role === 'admin' && /^0\dOW\d{3}$/.test(leader.tp)) ? ok('confirming the email creates the team and a TeamPulse ID (' + leader.tp + ')') : fail('the team was not created');
  frameDoc().querySelector('[data-r=dashboard]').click();
  await wait(300);
  frameDoc().body.innerText.includes('Get started') ? ok('the new team starts empty, with a getting-started list') : fail('the empty dashboard is wrong');
});

await step('adding a member sends an invitation', async () => {
  const w = frameWin(), d = frameDoc();
  d.querySelector('[data-r=addmember]').click();
  await wait(300);
  fill(d.querySelector('[data-form=addmember]'), { name: 'First Member', email: 'member@example.com', phone: '', neo: '063-1000002', pv: '136', sponsor: w.TP.me().id });
  await wait(500);
  const m = w.TP.db().users.find(u => u.name === 'First Member');
  (m && m.status === 'invited' && !m.pwHash) ? ok('the member is added as invited, with no password yet') : fail('the member was not added correctly');
  w.TP.mail()[0].subject.startsWith('Welcome') ? ok('the welcome email with the set-password link was sent') : fail('no welcome email');
});

await step('the member sets a password and signs in', async () => {
  const w = frameWin();
  const welcome = w.TP.mail().find(m => m.toName === 'First Member');
  frameDoc().querySelector('[data-act=signout]').click();
  await wait(300);
  w.TP.openCta(welcome.id);
  await wait(400);
  fill(frameDoc().querySelector('[data-form=setpw]'), { p1: 'Member2026', p2: 'Member2026' });
  await wait(900);
  const me = w.TP.me();
  (me && me.name === 'First Member' && me.role === 'member') ? ok('the member sets a password and lands on their own home page') : fail('the member journey failed');
});

try { localStorage.clear(); } catch (e) {}
return out.join('\n');
