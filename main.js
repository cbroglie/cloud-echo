addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

/**
 * Fetch and log a request
 * @param {Request} request
 */
async function handleRequest(request) {
  var text = [];
  text.push(
    '        _  _',
    '       ( `   )_',
    '      (    )    `)',
    '    (_   (_ .  _) _)',
    '',
    'Request headers:'
  );
  console.log('Got request', request)
  for (var pair of request.headers.entries()) {
    text.push('  ' + pair[0]+ ': ' + pair[1]);
  }

  const headers = new Headers();
  headers.append("Content-Type", "text/plain")
  const response = new Response(text.join('\n'), {
    status: 200,
    headers: headers
  });

  console.log('Got response', response)
  return response
}