import {Fragment, Suspense, useContext} from 'react';
import {Routes, Route, Navigate, useLocation} from 'react-router-dom';
import {useAuthValue, useRefreshAuth, Protected} from '@xorkevin/turbine';
import {
  MainContent,
  Section,
  Container,
  SnackbarContainer,
  NavItem,
  MenuItem,
  MenuHeader,
  Footer,
  Grid,
  Column,
  FaIcon,
} from '@xorkevin/nuke';
import AnchorSecondary from '@xorkevin/nuke/src/component/anchor/secondary';
import {
  GovUICtx,
  NavContainer,
  LoginContainer,
  OAuthContainer,
  AccountContainer,
  UserContainer,
  OrgContainer,
  AdminContainer,
  CourierContainer,
  SetupContainer,
} from '@xorkevin/gov-ui';

import {permissionedRoles} from 'roles';

const AccountC = Protected(AccountContainer);
const UserC = Protected(UserContainer);
const OrgC = Protected(OrgContainer);
const AdminC = Protected(AdminContainer, permissionedRoles);
const CourierC = Protected(CourierContainer);

const Foot = () => {
  return (
    <Footer>
      <Grid className="dark" justify="center" align="center">
        <Column fullWidth sm={8}>
          <div className="text-center">
            <h4>Gov UI</h4> a reactive frontend for governor
            <ul>
              <li>
                <AnchorSecondary ext href="https://github.com/xorkevin/gov-ui">
                  <FaIcon icon="github" /> Github
                </AnchorSecondary>
              </li>
              <li>
                Designed for{' '}
                <AnchorSecondary
                  ext
                  href="https://github.com/xorkevin/governor"
                >
                  xorkevin/governor
                </AnchorSecondary>
              </li>
            </ul>
            <h5>
              <FaIcon icon="code" /> with <FaIcon icon="heart-o" /> by{' '}
              <AnchorSecondary ext href="https://xorkevin.com/">
                <FaIcon icon="github" /> xorkevin
              </AnchorSecondary>
            </h5>
          </div>
        </Column>
      </Grid>
    </Footer>
  );
};

const Home = () => {
  return (
    <MainContent>
      <Section>
        <Container padded>
          <h1>xorkevin labs</h1>
        </Container>
      </Section>
    </MainContent>
  );
};

const hideNavPrefixes = Object.freeze(['/oauth', '/conduit']);

const App = () => {
  const ctx = useContext(GovUICtx);
  const {loggedIn} = useAuthValue();
  useRefreshAuth();

  const loc = useLocation();
  const hideNav = hideNavPrefixes.some((i) => loc.pathname.startsWith(i));

  return (
    <div>
      {hideNav ? null : (
        <NavContainer
          closeOnClick
          menuend={
            <Fragment>
              <MenuHeader>About</MenuHeader>
              <MenuItem
                ext
                link="https://xorkevin.com/"
                icon={<FaIcon icon="globe-w" />}
                label={<FaIcon icon="external-link" />}
              >
                xorkevin
              </MenuItem>
            </Fragment>
          }
        >
          <NavItem local link="/">
            <FaIcon icon="home" />
            <small>Home</small>
          </NavItem>
          {loggedIn && (
            <Fragment>
              <NavItem local link="/admin">
                <FaIcon icon="building-o" />
                <small>Admin</small>
              </NavItem>
              {ctx.enableCourier && (
                <NavItem local link="/courier">
                  <FaIcon icon="paper-plane" />
                  <small>Courier</small>
                </NavItem>
              )}
            </Fragment>
          )}
        </NavContainer>
      )}

      <Suspense fallback={ctx.mainFallbackView}>
        <Routes>
          <Route index element={<Home />} />
          <Route path="/x/*" element={<LoginContainer />} />
          {ctx.enableOAuth && (
            <Route path="/oauth/*" element={<OAuthContainer />} />
          )}
          <Route path="/a/*" element={<AccountC />} />
          <Route path="/u/*" element={<UserC />} />
          {ctx.enableUserOrgs && <Route path="/org/*" element={<OrgC />} />}
          <Route path="/admin/*" element={<AdminC />} />
          {ctx.enableCourier && (
            <Route path="/courier/*" element={<CourierC />} />
          )}
          <Route path="/setup" element={<SetupContainer />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </Suspense>

      {hideNav ? null : <Foot />}
      <SnackbarContainer />
    </div>
  );
};

export default App;
