import { AuthRequest, ResponseType } from 'expo-auth-session';

import { scopesFor, type Authorizer } from './ynabAuthorize';

/**
 * The real trip to YNAB, through the system browser.
 *
 * `expo-auth-session` builds the URL, generates the `state`, opens the
 * browser, and checks the `state` on the way back — which is the part that
 * matters, because a redirect carrying a code the app did not ask for is how
 * an authorization-code flow is attacked. `AuthRequest` reports a returned
 * state that is not the one it sent as an error, which is why there is no
 * check for it here.
 *
 * The one module that names `expo-auth-session`, so the session around it runs
 * under vitest against a stub.
 */
export const systemBrowserAuthorizer: Authorizer = {
  async authorize({ authorizeUrl, clientId, redirectUri, write }) {
    const request = new AuthRequest({
      clientId,
      redirectUri,
      responseType: ResponseType.Code,
      scopes: scopesFor(write),
      usePKCE: false,
    });

    const result = await request.promptAsync({ authorizationEndpoint: authorizeUrl });

    switch (result.type) {
      case 'success': {
        const code = result.params.code;
        if (typeof code !== 'string' || code === '') {
          throw new Error('YNAB redirected back without an authorization code.');
        }

        return { kind: 'authorized', code };
      }

      case 'error':
        // Includes `state_mismatch`, which `AuthRequest` raises when the
        // returned state is not the one it sent.
        throw new Error(
          result.error?.description ?? result.error?.message ?? 'YNAB refused the request.',
        );

      default:
        // `cancel` and `dismiss`: the person backed out.
        return { kind: 'dismissed' };
    }
  },
};
